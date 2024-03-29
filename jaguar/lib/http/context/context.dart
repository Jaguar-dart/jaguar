/// Declares the Jaguar `Context` class
library jaguar.src.http.context;

import 'dart:async';

import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:logging/logging.dart';
import 'dart:convert' as conv;
import 'package:auth_header/auth_header.dart';

import 'package:mime/mime.dart';
import 'package:http_server/http_server.dart';

/// Per-request context object that encapsulates all the data corresponding to
/// a HTTP request and provides a way to write [response]. It provides various
/// convenience methods and getters to access HTTP request data:
///
/// 1. [Request] object ([req])
/// 2. [Response] object ([response])
/// 3. Path parameters ([pathParams])
/// 4. Query parameters ([query])
/// 5. Body parsers ([body], [bodyAsText], [bodyAsStream], [bodyAsJson], [bodyAsFormData], [bodyAsUrlEncodedForm])
/// 6. Route variables ([getVariable])
/// 7. Interceptors ([after], [before])
/// 8. Session object ([session])
///
/// Example showing how to access query parameters using [Context] object.
///     int add(Context ctx) => ctx.query.getInt('a') + ctx.query.getInt('b');
class Context {
  /// When the request arrived
  final DateTime at;

  /// Uri of the HTTP request
  Uri get uri => req.uri;

  /// Path of the HTTP request
  String get path => uri.path;

  /// Path segments of the HTTP request
  List<String> get pathSegments => uri.pathSegments;

  /// Method of the HTTP request
  String get method => req.method;

  /// [Request] object of the current HTTP request.
  ///
  /// Example:
  ///
  ///     final server = Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final List json = await ctx.req.bodyAsJsonList();
  ///       // ...
  ///     });
  ///     await server.serve();
  final Request req;

  /// Path parameters
  ///
  /// Example:
  ///
  ///     server.get('/api/quote/:index', (ctx) { // The magic!
  ///       final int index = ctx.pathParams.getInt('index', 1);  // The magic!
  ///       return quotes[index + 1];
  ///     });
  final pathParams = PathParams();

  QueryParams? _query;

  /// Returns query parameters of the request
  ///
  /// Lazily creates query parameters to enhance performance of route handling.
  ///
  /// Example:
  ///
  ///     server.get('/api/quote', (ctx) {
  ///       final int index = ctx.query.getInt('index', 1); // The magic!
  ///       return quotes[index + 1];
  ///     });
  QueryParams get query => _query ??= QueryParams(req.uri.queryParameters);

  /// The registered route that matched the HTTP request.
  Route? route;

  /// Session manager to parse and write session data.
  SessionManager? sessionManager;

  /// User fetchers for authentication and authorization.
  final Map<Type, UserFetcher<AuthorizationUser>> userFetchers;

  Session? _session;

  /// Does the session need update?
  bool get sessionNeedsUpdate => _session != null && _session!.needsUpdate;

  /// Parsed session. Returns null, if the session is not parsed yet.
  Session? get parsedSession => _session;

  /// The session for the given request.
  ///
  /// Example:
  ///
  ///     server.get('/api/set/:item', (ctx) async {
  ///       final Session session = await ctx.req.session;
  ///       session['item'] = ctx.pathParams.item;
  ///       // ...
  ///     });
  Future<Session?> get session async =>
      _session ??= await sessionManager?.parse(this);

  /// Logger that can be used to log from middlerware and route handlers.
  final Logger log;

  Context(this.req,
      {this.sessionManager,
      required this.log,
      required this.userFetchers,
      required this.before,
      required this.after,
      required this.onException,
      DateTime? at})
      : at = at ?? DateTime.now().toUtc();

  final _variables = <String, dynamic>{};

  /// Adds a named variable to the context
  void addVariable(value, {required String id}) {
    _variables[id] = value;
  }

  /// Adds a named variables to the context
  void addVariables(Map<String, dynamic> variables) {
    _variables.addAll(variables);
  }

  /// Returns variable by id
  T getVariable<T>({required String id}) {
    return _variables[id] as T;
  }

  final _variablesByType = [];

  /// Adds a named variable to the context
  void addVariableByType(value) {
    _variablesByType.add(value);
  }

  void addVariablesByType(List values) {
    _variablesByType.addAll(values);
  }

  /// Returns variable by type
  T? getVariableByType<T>({T? orElse}) {
    for (final v in _variablesByType.reversed) {
      if (v is T) {
        return v;
      }
    }
    return orElse;
  }

  /// Headers in the HTTP request.
  HttpHeaders get headers => req.headers;

  ContentType? get contentType => req.headers.contentType;

  MimeType? _mimeType;

  MimeType _parseMimeType() {
    final contentType = this.contentType;
    if (contentType == null) {
      return MimeType.octetStream;
    }

    return MimeType(contentType.primaryType, contentType.subType);
  }

  /// Returns mime type of the HTTP request
  MimeType get mimeType => _mimeType ??= _parseMimeType();

  /// Returns true if the mime type of HTTP request is JSON.
  bool get isJson => mimeType.isJson;

  /// Returns true if the mime type of HTTP request is url-encoded-form.
  bool get isUrlEncodedForm => mimeType.isUrlEncodedForm;

  /// Returns true if the mime type of HTTP request is form-data.
  bool get isFormData => mimeType.isFormData;

  Map<String, MimeType>? _accepts;

  // Parses accepts header
  Map<String, MimeType> _parseAccepts() {
    final ret = <String, MimeType>{};
    if (headers['Accept'] == null) {
      return ret;
    }

    List<String> accepts = headers.value('Accept')?.split(',') ?? [];
    for (String accept in accepts) {
      MimeType ct = MimeType.parse(accept);
      ret[ct.mimeType] = ct;
    }

    return ret;
  }

  /// Returns mime types of the response accepted by the client of the HTTP
  /// request.
  Map<String, MimeType> get accepts => _accepts ??= _parseAccepts();

  /// Returns true if the client accepts the response body in HTML format.
  bool get acceptsHtml => accepts.containsKey(MimeTypes.html);

  /// Returns true if the client accepts the response body in JSON format.
  bool get acceptsJson => accepts.containsKey(MimeTypes.json);

  /// Private cache for request body
  List<int>? _body;

  /// Returns body of HTTP request as bytes.
  Future<List<int>> get body async => _body ??= await req.body;

  /// Returns the body of HTTP request as stream of bytes.
  Future<Stream<List<int>>> get bodyAsStream async {
    final List<int> bodyRaw = await body;
    return Stream<List<int>>.fromIterable(<List<int>>[bodyRaw]);
  }

  /// Returns body as text
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final String body = await ctx.req.bodyAsText();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<String> bodyAsText([conv.Encoding encoding = conv.utf8]) async {
    return encoding.decode(await body);
  }

  /*
  /// Deserializes body by mimetype using [_serializers]
  Future<T> bodyDecode<T>() async {
    final codec = _serializers[mimeType.mimeType];
    if (codec is CodecRepo<String>) {
      return codec.decode<T>(await bodyAsText());
    } else if (codec is CodecRepo<List<int>>) {
      return codec.decode<T>(await body);
    }
    throw Exception("Do not have codec for mimetype: ${mimeType.mimeType}");
  }
   */

  /// Decodes JSON body of the request
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final json = await ctx.req.bodyAsJson();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<T> bodyAsJson<T, F>(
      {conv.Encoding encoding = conv.utf8,
      Converter<T, F>? convert,
      Type? type}) async {
    final String text = await bodyAsText(encoding);
    final dec = conv.json.decode(text);
    if (convert != null) {
      return convert(dec);
    }
    /*{
      final repo = _serializers[MimeTypes.json];
      if (repo != null) {
        final ser = repo.getByType<T>(type ?? T);
        if (ser != null && dec is Map) {
          return ser.fromMap(dec);
        }
      }
    }*/
    return dec;
  }

  /// Decodes JSON body of the request as [Map]
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final Map<String, dynamic> json = await ctx.req.bodyAsJsonMap();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<Map> bodyAsJsonMap({conv.Encoding encoding = conv.utf8}) async {
    final String text = await bodyAsText(encoding);
    final ret = conv.json.decode(text);
    return ret;
  }

  /// Decodes JSON body of the request as [List]
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final List json = await ctx.req.bodyAsJsonList();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<List<T>?> bodyAsJsonList<T, F>(
      {conv.Encoding encoding = conv.utf8,
      Converter<T, F>? convert,
      Type? type}) async {
    final String text = await bodyAsText(encoding);
    final List? ret = conv.json.decode(text);
    if (ret == null) {
      return null;
    }
    if (convert != null) {
      return ret.cast<F>().map(convert).toList();
    }
    /*{
      final repo = _serializers[MimeTypes.json];
      if (repo != null) {
        final ser = repo.getByType<T>(type ?? T);
        if (ser != null) {
          return ser.fromList(ret.cast<Map>());
        }
      }
    }*/
    return ret.cast<T>();
  }

  Map<String, String>? _parsedUrlEncodedForm;

  /// Decodes url-encoded form from the body and returns the form as
  /// Map<String, String>.
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/add', (ctx) async {
  ///       final Map<String, String> map = await ctx.req.bodyAsUrlEncodedForm();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<Map<String, String>> bodyAsUrlEncodedForm(
      {conv.Encoding encoding = conv.utf8}) async {
    if (_parsedUrlEncodedForm != null) {
      return _parsedUrlEncodedForm!;
    }

    final String text = await bodyAsText(encoding);

    List<String> fields = text.split("&");

    final ret = <String, String>{};

    for (String field in fields) {
      List<String> parts = field.split("=");
      if (parts.length == 2)
        ret[Uri.decodeQueryComponent(parts.first)] =
            Uri.decodeQueryComponent(parts.last);
      else
        ret[Uri.decodeQueryComponent(parts.first)] = "";
    }

    _parsedUrlEncodedForm = ret;
    return ret;
  }

  Map<String, FormField>? _parsedFormData;

  /// Decodes `multipart/form-data` body
  ///
  /// Example:
  ///     server.post('/upload', (ctx) async {
  ///       final Map<String, FormField> formData = await ctx.req.bodyAsFormData();
  ///       BinaryFileFormField pic = formData['pic'];
  ///       File file = new File('bin/data/' + pic.filename);
  ///       IOSink sink = file.openWrite();
  ///       await sink.addStream(pic.value);
  ///       await sink.close();
  ///       return Response.redirect(Uri.parse("/"));
  ///     });
  Future<Map<String, FormField>> bodyAsFormData() async {
    if (_parsedFormData != null) {
      return _parsedFormData!;
    }

    if (req.headers.contentType == null ||
        !req.headers.contentType!.parameters.containsKey('boundary')) {
      throw Exception(
          'request does not contain boundary specification for form-data');
    }

    final String boundary = req.headers.contentType!.parameters['boundary']!;

    final ret = <String, FormField>{};

    final Stream<List<int>> bodyStream = await bodyAsStream;

    // Transform body to [MimeMultipart]
    final transformer = MimeMultipartTransformer(boundary);
    final Stream<MimeMultipart> stream = transformer.bind(bodyStream);

    await for (MimeMultipart part in stream) {
      HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      // Parse field content type
      final ContentType? contentType = multipart.contentType;

      final String name = multipart.contentDisposition.parameters['name']!;

      final String? fn = multipart.contentDisposition.parameters['filename'];

      // Create field
      if (fn is! String && multipart.isText) {
        final String data = await multipart.join();
        final field = StringFormField(name, data, contentType: contentType);
        ret[field.name] = field;
      } else if (multipart.isText) {
        final field = TextFileFormField(name, multipart.cast<String>(),
            contentType: contentType, filename: fn);
        if (ret[name] is TextFileListFormField) {
          (ret[name] as TextFileListFormField).values.add(field);
        } else if (ret[name] is TextFileFormField) {
          ret[name] = TextFileListFormField.fromValues(
              [ret[name]! as TextFileFormField, field]);
        } else {
          ret[name] = field;
        }
      } else {
        final field = BinaryFileFormField(name, multipart.cast<List<int>>(),
            contentType: contentType, filename: fn);
        if (ret[name] is BinaryFileListFormField) {
          (ret[name] as BinaryFileListFormField).values.add(field);
        } else if (ret[name] is BinaryFileFormField) {
          ret[name] = BinaryFileListFormField.fromValues(
              [ret[name]! as BinaryFileFormField, field]);
        } else {
          ret[name] = field;
        }
      }
    }

    _parsedFormData = ret;
    return ret;
  }

  Future<Map?> bodyAsMap({conv.Encoding encoding = conv.utf8}) async {
    MimeType mt = mimeType;

    if (mt.isJson) {
      return bodyAsJsonMap(encoding: encoding);
    } else if (mt.isUrlEncodedForm) {
      return bodyAsUrlEncodedForm();
    } else if (mt.isFormData) {
      return _formDataMapToStringMap(await bodyAsFormData());
    }

    return null;
  }

  /// Converts the body to typ [T].
  Future<T> bodyTo<T>(Converter<T, dynamic> converter,
      {conv.Encoding encoding = conv.utf8}) async {
    MimeType mt = mimeType;

    Map? b;
    if (mt.isJson) {
      b = await bodyAsJsonMap(encoding: encoding);
    } else if (mt.isUrlEncodedForm) {
      b = await bodyAsUrlEncodedForm();
    } else if (mt.isFormData) {
      b = await _formDataMapToStringMap(await bodyAsFormData());
    }
    // TODO use serializer for other mimetypes

    return converter(b);
  }

  /// Returns file for given [field] in form-data body. Returns null, if the field
  /// is not found, not a file field or body is not form-data.
  Future<FileFormField<T>?> getFile<T>(String field) async {
    final data = await bodyAsFormData();
    final fieldData = data[field];
    if (fieldData is! FileFormField<T>) {
      return null;
    }
    return fieldData;
  }

  /// Returns file for given [field] in form-data body. Returns null, if the field
  /// is not found, not a file field or body is not form-data.
  Future<BinaryFileFormField?> getBinaryFile(String field) async {
    final data = await bodyAsFormData();
    final fieldData = data[field];
    if (fieldData is! BinaryFileFormField) {
      return null;
    }
    return fieldData;
  }

  /// Returns file for given [field] in form-data body. Returns null, if the field
  /// is not found, not a file field or body is not form-data.
  Future<TextFileFormField?> getTextFile(String field) async {
    final data = await bodyAsFormData();
    final fieldData = data[field];
    if (fieldData is! TextFileFormField) {
      return null;
    }
    return fieldData;
  }

  Response response = StringResponse();

  /// Exception handlers executed if there is an exception during the execution of
  /// the route.
  final List<ExceptionHandler> onException;

  /// Interceptors that shall be executed before route handler is executed.
  final List<RouteInterceptor> before;

  /// Interceptors that shall be executed after route handler is executed.
  ///
  /// These interceptors are executed in the reverse order of registration.
  final List<RouteInterceptor> after;

  /// Returns cookies set in HTTP request.
  Map<String, Cookie> get cookies => _cookies ??= _parseCookies();

  Map<String, Cookie>? _cookies;

  Map<String, Cookie> _parseCookies() {
    final ret = <String, Cookie>{};
    for (Cookie cookie in req.cookies) {
      ret[cookie.name] = cookie;
    }
    return ret;
  }

  AuthHeaders? _authHeader;

  /// Returns auth header for the requested [scheme].
  String? authHeader(String scheme) {
    if (_authHeader == null) {
      _authHeader = AuthHeaders.fromHeaderStr(
          req.headers.value(HttpHeaders.authorizationHeader));
    }
    return _authHeader!.items[scheme]?.credentials;
  }

  /// Executes the [route] with this [Context].
  ///
  /// Takes responsibility of executing [after] and [before] interceptors.
  /// Tries to automatically construct response from returned result if the
  /// response is not explicitly set in route handler.
  Future<void> execute() async {
    dynamic maybeFuture;
    for (int i = 0; i < before.length; i++) {
      maybeFuture = before[i](this);
      if (maybeFuture is Future) await maybeFuture;
    }

    {
      final info = route!.info;
      dynamic res = route!.handler(this);
      if (res is Future) res = await res;

      if (res is Response) {
        response = res;
      } else {
        if (response.body == null) {
          if (info.responseProcessor != null) {
            maybeFuture = info.responseProcessor!(this, res);
            if (maybeFuture is Future) await maybeFuture;
          } else if (res != null) {
            response = StringResponse.cloneFrom(response,
                body: res,
                statusCode: info.statusCode,
                mimeType: info.mimeType,
                charset: info.charset);
          }
        }
      }
    }

    for (int i = after.length - 1; i >= 0; i--) {
      maybeFuture = after[i](this);
      if (maybeFuture is Future) await maybeFuture;
    }
  }
}

Map<String, String> _formDataMapToStringMap(Map<String, FormField> form) {
  final ret = <String, String>{};

  for (String key in form.keys) {
    if (form[key] is StringFormField) {
      ret[key] = form[key]!.value;
    }
  }

  return ret;
}

typedef Converter<T, F> = T Function(F d);
