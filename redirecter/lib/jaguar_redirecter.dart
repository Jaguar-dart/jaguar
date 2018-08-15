/// Support for doing something awesome.
///
/// More dartdocs go here.
library redirecter;

import 'package:jaguar/jaguar.dart';

/// Plugin to redirect HTTP requests to HTTPS requests.
///
/// Example:
///       final redir = Jaguar(port: 10000);
//        redir.addRoute(httpsRedirecter());
//        await redir.serve();
Route httpsRedirecter(
    {String path: '*',
    ResponseProcessor responseProcessor,
    Map<String, String> pathRegEx,
    String host,
    int port: 443}) {
  return Route(path, (ctx) {
    final Uri originalUri = ctx.req.requestedUri;
    Uri uri = Uri(
        scheme: 'https',
        userInfo: originalUri.userInfo,
        host: host ?? originalUri.host,
        port: port,
        path: originalUri.path,
        query: originalUri.query);
    if (ctx.method == 'GET') {
      ctx.response = Redirect(uri);
    } else {
      ctx.response = Redirect.temporaryRedirect(uri);
    }
  }, responseProcessor: responseProcessor, pathRegEx: pathRegEx);
}
