// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Provides [getOnlyProxy] to reverse proxy certain selected requests to
/// another server.
/// This is similar to Nginx's reverse proxy.
library jaguar_dev_proxy;

import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:path/path.dart' as p;

/// Creates a route that proxies the requests matching the [path] to another
/// server at [proxyBaseUrl].
///
/// Example usage:
///     final server = Jaguar();
///     server.addRoute(getOnlyProxy('/client/*', 'http://localhost:8000/'));
///
/// [path] is used to match the incoming  URL/route. The matching is based on
/// prefix. For example:
///
/// When `path` is `/html/*`, it will match:
///
/// + `/html`
/// + `/html/`
/// + `/html/index.html`
/// + `/html/static/index.html`
///
/// The `proxyBaseUrl` is just prefixed to the remaining part after `path` is
/// matched. For example:
///
/// For `getOnlyProxy('/html/*', 'http://localhost:8000/client')`,
///
/// + `/html` is mapped into `http://localhost:8000/client/`
/// + `/html/` is mapped into `http://localhost:8000/client/`
/// + `/html/index.html` is mapped into `http://localhost:8000/client/index.html`
/// + `/html/static/index.html` is mapped into `http://localhost:8000/client/static/index.html`
//TODO add timeout
Route getOnlyProxy(String path, String proxyBaseUrl,
    {Map<String, String> pathRegEx,
    ResponseProcessor responseProcessor,
    bool stripPrefix: true,
    String proxyName: 'jaguar_proxy',
    HttpClient client}) {
  client ??= HttpClient();

  Route route;
  int skipCount;
  route = Route.get(path, (ctx) async {
    Iterable<String> segs = ctx.pathSegments;
    if (stripPrefix) segs = segs.skip(skipCount);
    Uri requestUri = Uri.parse(proxyBaseUrl + '/' + segs.join('/'));
    HttpClientRequest clientReq =
        await client.openUrl(ctx.req.method, requestUri);
    clientReq.followRedirects = false;

    ctx.req.headers.forEach((String key, dynamic val) {
      clientReq.headers.add(key, val);
    });
    // TODO add forward headers
    clientReq.headers.set('Host', requestUri.authority);

    // Add a Via header. See
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.45
    clientReq.headers.add('via', '${ctx.req.protocolVersion} $proxyName');

    clientReq.add(await ctx.req.body);
    final HttpClientResponse clientResp = await clientReq.close();

    if (clientResp.statusCode == HttpStatus.notFound)
      return Builtin404ErrorResponse();

    _returnResponse(ctx, clientResp, requestUri, proxyName, proxyBaseUrl);
  }, responseProcessor: responseProcessor, pathRegEx: pathRegEx);

  if (stripPrefix) {
    if (route.pathSegments.isNotEmpty)
      skipCount = route.pathSegments.length - 1;
  }
  return route;
}

void _returnResponse(Context ctx, HttpClientResponse clientResp, Uri requestUri,
    String proxyName, String proxyBaseUrl) {
  final servResp =
      StreamResponse(clientResp, statusCode: clientResp.statusCode);

  clientResp.headers.forEach((String key, dynamic val) {
    servResp.headers.add(key, val);
  });

  // Add a Via header. See
  // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.45
  servResp.headers.add('via', '1.1 $proxyName');

  // Remove the transfer-encoding since the body has already been decoded by
  // [client].
  servResp.headers.removeAll('transfer-encoding');

  // If the original response was gzipped, it will be decoded by [client]
  // and we'll have no way of knowing its actual content-length.
  if (clientResp.headers.value('content-encoding') == 'gzip') {
    servResp.headers.removeAll('content-encoding');
    servResp.headers.removeAll('content-length');

    // Add a Warning header. See
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.5.2
    servResp.headers.add('warning', '214 $proxyName "GZIP decoded"');
  }

  // Make sure the Location header is pointing to the proxy server rather
  // than the destination server, if possible.
  if (clientResp.isRedirect && clientResp.headers.value('location') != null) {
    String location =
        requestUri.resolve(clientResp.headers.value('location')).toString();
    if (p.url.isWithin(proxyBaseUrl, location)) {
      // TODO add prefix
      servResp.headers
          .set('location', '/' + p.url.relative(location, from: proxyBaseUrl));
    } else {
      servResp.headers.set('location', location);
    }
  }

  ctx.response = servResp;
}
