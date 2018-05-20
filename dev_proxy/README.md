# jaguar_dev_proxy

Provides [`PrefixedProxyServer`](https://www.dartdocs.org/documentation/jaguar_dev_proxy/0.0.5/jaguar_dev_proxy/PrefixedProxyServer-class.html)
to reverse proxy certain selected requests to another server.

This is similar to Nginx's reverse proxy.

# Usage

An instance of `PrefixedProxyServer` has to be created and added to a
Jaguar server. The constructor of `PrefixedProxyServer` takes all the
necessary parameters to configure the reverse proxy.

The job of the reverse proxy is to

1. Match certain paths
2. Transform it to a target path
3. Forward the received request to the target path
4. Forward the response obtained from server to the client

Step 1 and 2 requires configuration.

# The matched path

The first parameter (`path`) to the constructor is used to match the incoming
URL/route. The matching is based on prefix. For example:

When `path` is `/html`, it will match:

+ `/html`
+ `/html/`
+ `/html/index.html`
+ `/html/static/index.html`

# Target path

The second parameter (`proxyBaseUrl`) is used to transform the incoming
request URL to reverse proxy target URL. The `proxyBaseUrl` is just prefixed
to the remaining part after `path` is matched match. For example:

For `new PrefixedProxyServer('/html', 'http://localhost:8000/client')`,

+ `/html` is mapped into `http://localhost:8000/client/`
+ `/html/` is mapped into `http://localhost:8000/client/`
+ `/html/index.html` is mapped into `http://localhost:8000/client/index.html`
+ `/html/static/index.html` is mapped into `http://localhost:8000/client/static/index.html`

# Boilerplate

The boilerplate example to showcasing reverse proxy capabilities of Jaguar
can be found at [Reverse proxy example](https://github.com/jaguar-examples/reverse_proxy).

# Simple example

A simple usage example:

```dart
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';

main() async {
  // Proxy all html client requests to pub server
  // NOTE: Run pub server on port 8000 using command
  //     pub serve --port 8000
  final proxy = new PrefixedProxyServer('/client', 'http://localhost:8000/');

  final server = new Jaguar(address: 'localhost', port: 8085);
  server.add(proxy);
  server.getJson('/api/user', (Context ctx) => {'name': 'teja'});
  server.get('/client/version', (Context ctx) => '0.1');
  await server.serve();
}
```
