import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_oauth/jaguar_oauth.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:logging/logging.dart';
import 'package:jaguar_facebook_client/jaguar_facebook_client.dart' as fb;

class User {
  /// ID for the user in the database
  String id;

  /// User name
  String name;

  /// User's email
  String email;

  String dateOfBirth;

  String bio;

  /// Token to access user's facebook account
  String fbToken;

  /// Token to refresh user's facebook account token [fbToken]
  //TODO needed? String fbRefreshToken;

  /// Facebook ID of the user
  String fbId;
}

@Api(path: '/auth')
class AuthRoutes {
  /// Route that initiates the OAuth2 authorization request by redirecting to
  /// authorization endpoint
  @Get(path: '/fb/authreq')
  Response<Uri> fbAuthReq(ctx) => facebook.initiateRequest(ctx);

  /// Route that handles OAuth2 authorization response callback
  @Get(path: '/fb/authorized', mimeType: 'application/json')
  Future<String> fbAuthorized(Context ctx) async {
    // Get the [Client] from authorization response callback
    oauth2.Client client = await facebook.handleResponse(ctx);
    // Use Facebook OAuth2 APIs
    final graph = new fb.GraphApi(client);
    final fields = new fb.UserFieldSelector()
      ..addBirthday()
      ..addAbout()
      ..addEmail()
      ..addName();
    final resp = await graph.getMe(fields: fields);
    return resp.map.toString();
  }

  /// Facebook OAuth2 configuration
  JaguarOauth2 get facebook => new JaguarOauth2(
      key: fbOauthKey,
      secret: fbOauthSecret,
      authorizationEndpoint: 'https://www.facebook.com/dialog/oauth',
      tokenEndpoint: 'https://graph.facebook.com/v2.8/oauth/access_token',
      callback: baseUrl + '/api/auth/fb/authorized',
      scopes: [fb.Scope.email, fb.Scope.userAboutMe, fb.Scope.publicProfile]);
}

@Api(path: '/api')
class MyApi {
  @IncludeApi()
  final AuthRoutes auth = new AuthRoutes();
}

const String baseUrl = 'http://localhost:5555';
String get fbOauthKey => Settings.getString('facebook_oauth_key',
    settingsFilter: SettingsFilter.Env);
String get fbOauthSecret => Settings.getString('facebook_oauth_secret',
    settingsFilter: SettingsFilter.Env);

main(List<String> args) async {
  await Settings.parse(args);
  final server = new Jaguar(port: 5555);
  server.addApiReflected(new MyApi());

  server.log.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  await server.serve();
}
