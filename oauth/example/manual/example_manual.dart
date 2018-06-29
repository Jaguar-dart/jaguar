import 'dart:io';
import 'package:jaguar_oauth/jaguar_oauth.dart';
import 'package:oauth2/oauth2.dart';
import 'package:jaguar_settings/jaguar_settings.dart';

String get fbOauthKey => Settings.getString('facebook_oauth_key',
    settingsFilter: SettingsFilter.Env);
String get fbOauthSecret => Settings.getString('facebook_oauth_secret',
    settingsFilter: SettingsFilter.Env);

main(List<String> args) async {
  await Settings.parse(args);

  // Create the OAuth2 config
  final config = new JaguarOauth2(
      key: fbOauthKey, // Facebook OAuth key
      secret: fbOauthSecret, // Facebook OAuth secret
      authorizationEndpoint: 'https://www.facebook.com/dialog/oauth',
      tokenEndpoint: 'https://graph.facebook.com/v2.8/oauth/access_token',
      callback: 'http://localhost:5555/api/auth/fb/login/authorized',
      scopes: ['email']);

  // Print the authorization url
  print('Authorization url: ');
  print(config.authorizationUrl);

  print('Open the authorization URL in the browser.');
  print('Get the response code from Facebook.');

  // Get the response code
  stdout.write('Enter the code: ');
  String code = stdin.readLineSync();

  // Get HTTP [Client] from authorization response
  final Client client = await config.handleResponseWithParam({'code': code});

  // Fetch user profile
  final resp = await client.get('https://graph.facebook.com/v2.8/me');
  print(resp.body);
  exit(0);
}
