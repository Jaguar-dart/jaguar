# jaguar_oauth

OAuth interceptors for Jaguar.

`JaguarOauth2` provides an easy way to initiate an OAuth2 authorization
request and handle the authorization response callback.

## Example

```dart
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
    final resp = await client.get('https://graph.facebook.com/v2.8/me');
    return resp.body;
  }

  /// Facebook OAuth2 configuration
  JaguarOauth2 get facebook => new JaguarOauth2(
      key: fbOauthKey,
      secret: fbOauthSecret,
      authorizationEndpoint: 'https://www.facebook.com/dialog/oauth',
      tokenEndpoint: 'https://graph.facebook.com/v2.8/oauth/access_token',
      callback: baseUrl + '/api/auth/fb/authorized',
      scopes: ['email']);
}
```

## Example usage outside Jaguar routes

```dart
main(List<String> args) async {
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
```
