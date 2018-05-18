# jaguar_cors

CORS interceptor for Jaguar.dart servers

# Example

A complete example can be found [here](https://github.com/Jaguar-examples/cors).

```dart
library main;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_cors/jaguar_cors.dart';

static const corsOptions = const CorsOptions(
  allowedOrigins: const ['http://mine.com'],
  allowAllHeaders: true,
  allowAllMethods: true);

Cors cors(Context ctx) => new Cors(corsOptions);

@Api(path: '/api')
class Routes extends Object with CorsHelper {
  @Route(methods: const ['GET', 'OPTIONS'])
  @WrapOne(cors)
  Response<String> get(Context ctx) {
    if(ctx.req.method != 'GET') return null;
    return Response.json('Hello foreigner!');
  }

  @Route(methods: const ['POST', 'OPTIONS'])
  @WrapOne(cors)
  Future<Response<String>> post(Context ctx) async {
    if(ctx.req.method != 'POST') return null;
    return Response.json(await ctx.req.bodyAsJson());
  }
}

main() async {
  final server = new Jaguar(port: 9000);
  server.addApi(reflect(new Routes()));
  server.log.onRecord.listen(print);
  await server.serve();
}
```

# Docs

## Configuring Cors interceptor

CorsOptions is used to configure `Cors` Interceptor.

* **allowedOrigins** `List<String>`: A list of origins a cross-domain request can be executed from. Setting [allowAllOrigins] 
to [true] overrides [allowedOrigins] and allows all origins.
* **allowAllOrigins** `bool`: Allows all origins. If set to `true`, overrides *allowedOrigins* option. 
* **allowedMethods** `List<String>`: A list of methods the client is allowed to use with cross-domain requests. Default 
value is simple methods (`GET` and `POST`).
* **allowAllMethods** `bool`: Allows all methods. If set to `true`, overrides *allowedMethods* option. 
* **allowedHeaders** `List<String>`: A list of non simple headers the client is allowed to use with cross-domain requests.
* **allowAllHeaders** `bool`: Allows all headers. If set to `true`, overrides *allowedHeaders* option. 
* **exposeHeaders** `List<String>`: Indicates which headers are safe to expose to the API of a CORS API specification
* **exposeAllHeaders** `bool`: Exposes all headers. If set to `true`, overrides *exposeHeaders* option. 
* **allowCredentials** `bool`: Indicates whether the request can include user credentials like cookies, HTTP authentication 
or client side SSL certificates. The default is `false`.
* **maxAge** `int`: Indicates how long (in seconds) the results of a preflight request can be cached. The default is `0` 
which stands for no max age.
* **vary** `bool`: 
* **allowNonCorsRequests** `bool`: Should non-CORS requests be allowed?

See [API documentation](https://www.dartdocs.org/documentation/jaguar_cors/latest/jaguar_cors/CorsOptions-class.html) for more info.

### Example

```dart
static const options = const CorsOptions(
      allowedOrigins: const ['http://mine.com'],
      // allowedHeaders: const ['X-Requested-With'],
      allowAllHeaders: true,
      allowAllMethods: true);
```

## Wrapping the Cors interceptor

The `Cors` interceptor itself is simple to use. It accepts a `CorsOptions` object as configuration. 

**Note**:
1. Make sure that the route handler method/function accepts *OPTIONS* method.
2. If same route handler method/function is used to handle both preflight and actual route, the actual route body is
skipped during preflight requests

```dart
  @Route(methods: const ['GET', 'OPTIONS'])
  @WrapOne(cors)
  Response<String> get(Context ctx) {
    if(ctx.req.method != 'GET') return null;  // Skips for preflight requests
    return Response.json('Hello foreigner!');
  }
```

### Example

```dart
	Cors cors(Context ctx) => new Cors(options);

  @Route(methods: const ['GET', 'OPTIONS'])
  @WrapOne(cors)
  Response<String> get(Context ctx) {
    if(ctx.req.method != 'GET') return null;
    return Response.json('Hello foreigner!');
  }
```