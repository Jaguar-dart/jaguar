/// Declares the Jaguar `Context` class
library jaguar.src.http.context;

import 'dart:async';

import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:logging/logging.dart';
import 'dart:convert' as conv;
import 'package:auth_header/auth_header.dart';

import 'package:mime/mime.dart';
import 'package:http_server/http_server.dart';

/// Per-request context object
///
/// Contains:
/// 1. Request object
/// 2. Path parameters
/// 3. Query parameters
/// 4. Body parsers
/// 5. Route variables
/// 6. Interceptors
/// 7. Session object
class Context {
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

  QueryParams _query;

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
  QueryParams get query {
    if (_query != null) return _query;

    _query = new QueryParams(req.uri.queryParameters);
    return _query;
  }

  Route route;

  SessionManager sessionManager;

  final Map<Type, UserFetcher<AuthorizationUser>> userFetchers;

  Session _session;

  /// Does the session need update?
  bool get sessionNeedsUpdate => _session != null && _session.needsUpdate;

  /// Parsed session. Returns null, if the session is not parsed yet.
  Session get parsedSession => _session;

  /// The session for the given request.
  ///
  /// Example:
  ///
  ///     server.get('/api/set/:item', (ctx) async {
  ///       final Session session = await ctx.req.session;
  ///       session['item'] = ctx.pathParams.item;
  ///       // ...
  ///     });
  Future<Session> get session async =>
      _session ??= await sessionManager.parse(this);

  final Logger log;

  final Map<String, CodecRepo> _serializers;

  Context(this.req,
      {this.sessionManager,
      this.log,
      this.userFetchers,
      this.before,
      this.after,
      this.onException,
      Map<String, CodecRepo> serializers})
      : _serializers = serializers ?? <String, CodecRepo>{};

  final _variables = <Type, Map<String, dynamic>>{};

  /// Gets variable by type and id
  T getVariable<T>({String id, Type type}) {
    type ??= T;
    Map<String, dynamic> map = _variables[type];
    if (map != null) {
      if (id == null)
        return map.values.first;
      else {
        if (map.containsKey(id)) return map[id];
      }
    }

    if (T == dynamic) {
      return null;
    }

    if (id == null) {
      for (map in _variables.values) {
        for (dynamic v in map.values) {
          if (v is T) return v;
        }
      }
    } else {
      for (map in _variables.values) {
        if (map[id] is T) return map[id];
      }
    }

    return null;
  }

  /// Adds variable by type and id
  void addVariable<T>(T value, {String id}) {
    if (!_variables.containsKey(value.runtimeType)) {
      _variables[value.runtimeType] = {id: value};
    } else {
      _variables[value.runtimeType][id] = value;
    }
  }

  HttpHeaders get headers => req.headers;

  MimeType _mimeType;

  void _parseContentType() {
    if (req.headers['content-type'] != null) {
      String contentTypeStr = req.headers.value('content-type');
      _mimeType = MimeType.parse(contentTypeStr);
    } else {
      _mimeType = MimeType.binary;
    }
    // TODO charset
  }

  MimeType get mimeType {
    if (_mimeType == null) _parseContentType();
    return _mimeType;
  }

  bool get isJson => mimeType.isJson;

  bool get isUrlEncodedForm => mimeType.isUrlEncodedForm;

  bool get isFormData => mimeType.isFormData;

  Map<String, MimeType> _accepts;

  void _parseAccepts() {
    _accepts = {};
    if (headers['Accept'] == null) return;
    List<String> accepts = headers.value('Accept').split(',');
    for (String accept in accepts) {
      MimeType ct = MimeType.parse(accept);
      _accepts[ct.mimeType] = ct;
    }
  }

  Map<String, MimeType> get accepts {
    if (_accepts == null) _parseAccepts();
    return _accepts;
  }

  bool get acceptsHtml => accepts.containsKey(MimeTypes.html);

  bool get acceptsJson => accepts.containsKey(MimeTypes.json);

  /// Private cache for request body
  List<int> _body;

  Future<List<int>> get body async => _body ??= await req.body;

  /// Returns the body of HTTP request
  Future<Stream<List<int>>> get bodyAsStream async {
    final List<int> bodyRaw = await body;
    return new Stream<List<int>>.fromIterable(<List<int>>[bodyRaw]);
  }

  CodecRepo codecFor({String mimeType}) =>
      _serializers[mimeType ?? this.mimeType];

  Serializer<T> serializerFor<T>(Type type, {String mimeType}) {
    final codec = _serializers[mimeType ?? this.mimeType.mimeType];
    if (codec == null) return null;
    final ser = codec.getByType<T>(type ?? T);
    return ser;
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
      {conv.Encoding encoding: conv.utf8,
      Converter<T, F> convert,
      Type type}) async {
    final String text = await bodyAsText(encoding);
    final dec = conv.json.decode(text);
    if (convert != null) return convert(dec);
    {
      final repo = _serializers[MimeTypes.json];
      if (repo != null) {
        final ser = _serializers[MimeTypes.json].getByType<T>(type ?? T);
        if (ser != null && dec is Map) return ser.fromMap(dec);
      }
    }
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
  Future<Map> bodyAsJsonMap({conv.Encoding encoding: conv.utf8}) async {
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
  Future<List<T>> bodyAsJsonList<T, F>(
      {conv.Encoding encoding: conv.utf8,
      Converter<T, F> convert,
      Type type}) async {
    final String text = await bodyAsText(encoding);
    final List ret = conv.json.decode(text);
    if (convert != null) return ret.cast<F>().map(convert).toList();
    {
      final repo = _serializers[MimeTypes.json];
      if (repo != null) {
        final ser = _serializers[MimeTypes.json].getByType<T>(type ?? T);
        if (ser != null) return ser.fromList(ret);
      }
    }
    return ret.cast<T>();
  }

  Map<String, String> _parsedUrlEncodedForm;

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
      {conv.Encoding encoding: conv.utf8}) async {
    if (_parsedUrlEncodedForm != null) return _parsedUrlEncodedForm;

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

  Map<String, FormField> _parsedFormData;

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
    if (_parsedFormData != null) return _parsedFormData;

    if (!req.headers.contentType.parameters.containsKey('boundary')) {
      return null;
    }

    final String boundary = req.headers.contentType.parameters['boundary'];

    final ret = <String, FormField>{};

    final Stream<List<int>> bodyStream = await bodyAsStream;

    // Transform body to [MimeMultipart]
    final transformer = MimeMultipartTransformer(boundary);
    final Stream<MimeMultipart> stream = bodyStream.transform(transformer);

    await for (MimeMultipart part in stream) {
      HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      // Parse field content type
      final ContentType contentType = multipart.contentType;

      final String name = multipart.contentDisposition.parameters['name'];

      final String fn = multipart.contentDisposition.parameters['filename'];

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
          ret[name] = TextFileListFormField.fromValues([ret[name], field]);
        } else {
          ret[name] = field;
        }
      } else {
        final field = BinaryFileFormField(name, multipart.cast<List<int>>(),
            contentType: contentType, filename: fn);
        if (ret[name] is BinaryFileListFormField) {
          (ret[name] as BinaryFileListFormField).values.add(field);
        } else if (ret[name] is BinaryFileFormField) {
          ret[name] = BinaryFileListFormField.fromValues([ret[name], field]);
        } else {
          ret[name] = field;
        }
      }
    }

    _parsedFormData = ret;
    return ret;
  }

  Future<Map> bodyAsMap({conv.Encoding encoding: conv.utf8}) async {
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

  Future<T> bodyTo<T>(Converter<T, dynamic> convert,
      {conv.Encoding encoding: conv.utf8}) async {
    MimeType mt = mimeType;

    Map b;
    if (mt.isJson) {
      b = await bodyAsJsonMap(encoding: encoding);
    } else if (mt.isUrlEncodedForm) {
      b = await bodyAsUrlEncodedForm();
    } else if (mt.isFormData) {
      b = await _formDataMapToStringMap(await bodyAsFormData());
    }

    return convert(b);
  }

  Future<FormField<T>> getFile<T>(String field) async {
    final data = await bodyAsFormData();
    if (data == null) return null;
    final fieldData = data[field];
    if (fieldData is! FormField<T>) {
      return null;
    }
    return fieldData;
  }

  Response response;

  final List<ExceptionHandler> onException;

  final List<RouteInterceptor> before;

  final List<RouteInterceptor> after;

  Map<String, Cookie> get cookies => _cookies ??= _parseCookies();

  Map<String, Cookie> _cookies;

  Map<String, Cookie> _parseCookies() {
    final ret = <String, Cookie>{};
    for (Cookie cookie in req.cookies) {
      ret[cookie.name] = cookie;
    }
    return ret;
  }

  AuthHeaders _authHeader;

  String authHeader(String scheme) {
    if (_authHeader == null) {
      _authHeader = new AuthHeaders.fromHeaderStr(
          req.headers.value(HttpHeaders.authorizationHeader));
    }
    return _authHeader.items[scheme]?.credentials;
  }

  Future<void> execute() async {
    dynamic maybeFuture;
    for (int i = 0; i < before.length; i++) {
      maybeFuture = before[i](this);
      if (maybeFuture is Future) await maybeFuture;
    }

    {
      final info = route.info;
      dynamic res = route.handler(this);
      if (res is Future) res = await res;

      if (info.responseProcessor != null) {
        maybeFuture = info.responseProcessor(this, res);
      } else if (res != null) {
        if (res is Response)
          response = res;
        else {
          response = Response(res,
              statusCode: info.statusCode,
              mimeType: info.mimeType,
              charset: info.charset);
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
      ret[key] = form[key].value;
    }
  }

  return ret;
}

typedef Converter<T, F> = T Function(F d);
