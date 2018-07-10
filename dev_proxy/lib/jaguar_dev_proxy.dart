// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Provides [PrefixedProxyServer] to reverse proxy certain selected requests to
/// another server.
/// This is similar to Nginx's reverse proxy.
library jaguar_dev_proxy;

import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'package:jaguar/jaguar.dart';
import 'package:path/path.dart' as p;

/// Request handler to reverse proxy certain selected requests to another server
///
/// Example usage:
///     final proxy = new PrefixedProxyServer('/client', 'http://localhost:8000/');
///     final server = new Jaguar(address: 'localhost', port: 8085);
///     server.addApi(proxy);
class PrefixedProxyServer implements RequestHandler {
  /// Used to match incoming URLs
  final String path;

  /// Path segments of [path]
  final UnmodifiableListView<String> pathSegments;

  /// Used as prefix to transform incoming URL request to target URL
  final Uri proxyBaseUrl;

  /// Name of this proxy server
  final String proxyName;

  //TODO add timeout

  final HttpClient _client = new HttpClient();

  /// Creates a new instance of [PrefixedProxyServer]
  ///
  /// [path] is used to match the incoming  URL/route. The matching is based on
  /// prefix. For example:
  ///
  /// When `path` is `/html`, it will match:
  ///
  /// + `/html`
  /// + `/html/`
  /// + `/html/index.html`
  /// + `/html/static/index.html`
  ///
  /// used to transform the incoming
  /// request URL to reverse proxy target URL. The `proxyBaseUrl` is just prefixed
  /// to the remaining part after `path` is matched match. For example:
  ///
  /// For `new PrefixedProxyServer('/html', 'http://localhost:8000/client')`,
  ///
  /// + `/html` is mapped into `http://localhost:8000/client/`
  /// + `/html/` is mapped into `http://localhost:8000/client/`
  /// + `/html/index.html` is mapped into `http://localhost:8000/client/index.html`
  /// + `/html/static/index.html` is mapped into `http://localhost:8000/client/static/index.html`
  PrefixedProxyServer(this.path, String proxyBaseUrl,
      {this.proxyName: 'jaguar_proxy'})
      : pathSegments = new UnmodifiableListView(splitPathToSegments(path)),
        proxyBaseUrl = Uri.parse(proxyBaseUrl) {}

  /// Checks if the provided [reqUri] matches
  bool matches(Uri reqUri) {
    final List<String> reqSegs = reqUri.pathSegments;

    if (reqSegs.length < pathSegments.length) return false;

    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] == '*') continue;
      if (pathSegments[i] != reqSegs[i]) return false;
    }

    return true;
  }

  Uri _getTargetUrl(final Uri reqUri) {
    StringBuffer sb = new StringBuffer();

    sb.write(proxyBaseUrl);
    final List<String> segments = reqUri.pathSegments
        .getRange(pathSegments.length, reqUri.pathSegments.length)
        .toList();
    if (segments.length != 0) {
      if (!proxyBaseUrl.path.endsWith('/')) {
        sb.write('/');
      }
      sb.write(segments.join('/'));
    }
    if (reqUri.path.endsWith('/')) {
      sb.write('/');
    }

    return Uri.parse(sb.toString());
  }

  Future<void> handleRequest(Context ctx, {String prefix}) async {
    if (!matches(ctx.req.uri)) return null;

    // TODO: Handle TRACE requests correctly. See
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.8

    final requestUrl = _getTargetUrl(ctx.req.uri);
    final HttpClientRequest clientReq =
        await _client.openUrl(ctx.req.method, requestUrl);
    clientReq.followRedirects = false;

    ctx.req.headers.forEach((String key, dynamic val) {
      clientReq.headers.add(key, val);
    });
    //TODO add forward headers
    clientReq.headers.set('Host', proxyBaseUrl.authority);

    // Add a Via header. See
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.45
    clientReq.headers.add('via', '${ctx.req.protocolVersion} $proxyName');

    clientReq.add(await ctx.req.body);
    final HttpClientResponse clientResp = await clientReq.close();

    if (clientResp.statusCode == HttpStatus.notFound) {
      return null;
    }

    final servResp =
        new StreamResponse(clientResp, statusCode: clientResp.statusCode);

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
      var location =
          requestUrl.resolve(clientResp.headers.value('location')).toString();
      if (p.url.isWithin(proxyBaseUrl.toString(), location)) {
        servResp.headers.set('location',
            '/' + p.url.relative(location, from: proxyBaseUrl.toString()));
      } else {
        servResp.headers.set('location', location);
      }
    }

    ctx.response = servResp;
  }
}
