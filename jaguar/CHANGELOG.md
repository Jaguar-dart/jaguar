# Changelog

## 3.1.4

+ Fixed OnRouteServed issue

## 3.1.3

+ Fixed analyzer issues

## 3.1.2

+ Added wasm mime type

## 3.1.1
+ Added addVariablesByType to `Context`

## 3.1.0
*Breaking Changes:*
+ addVariable and getVariable only operate by id
+ id parameter on addVariable and getVariable are mandatory
+ Added addVariableByType and getVariableByType
+ RouteInterceptor does not take generic parameter

## 3.0.12

+ Fixed a bug involving `Jaguar.group`

## 3.0.10

+ `Jaguar` now exposes underlying `HttpServer`s as `servers` property

## 3.0.9

+ mimeTypeDetectors for static file serving routes

## 3.0.8

+ Repository in pubspec

## 3.0.6

+ `Context.response` is non-null

**Breaking changes**:

+ Changes to `Response` constructor
+ Renamed `Response.value`to `Response.body`

## 3.0.5

+ Null safe version release

## 3.0.2

+ Removed dependence on jaguar_serializer

## 3.0.1

+ Removed dependence on jaguar_serializer

## 3.0.0

+ Null safety

## 2.4.46

+ `Context.getVariable` returns by id if T is dynamic

## 2.4.45

+ `Context.getVariable` returns by id if T is dynamic

## 2.4.44

+ Upgraded `path_tree` dependency to version `2.4.44`

## 2.4.43

+ `QueryParams.toString()`

## 2.4.42

+ `Context.at` shows when the request arrived

## 2.4.41

+ `Jaguar.onRouteServed` callback

## 2.4.40

+ Exception handling of routes

## 2.4.39

+ Exception handling of routes

## 2.4.38

+ Use the response exception, before onException is called

## 2.4.37

+ `group` method inherits interceptors and exception handlers

## 2.4.35

+ `getBinaryFile` and `getTextFile` in `Context`

## 2.4.32

+ `WsStream` and `WsResponder` websocket handlers in controllers

## 2.4.31

+ `wsStream`, `wsResponder`, and `wsEcho` websocket handlers

## 2.4.26

+ Bug fixes
+ Improvements to `Context.execute` response handling

## 2.4.20

+ Bindings
+ Serializers

## 2.4.14

### Breaking changes

+ ErrorWriter interface has changed
+ Route handlers must now set response to `Builtin404ErrorResponse` to generate builtin 404 error response.

## 2.4.5

+ File `FormField` now supports multiple files in same field

## 2.4.4

+ Performance improvements

### Breaking changes

+ `onException` shall not throw. Should return response instead.

## 2.4.2

+ Interceptors have return types

## 2.4.1

+ `statusCode`, `mimeType` and `charset` are back in `HttpMethod` and `Route`.

### Breaking changes

+ Interceptor annotations are removed

## 2.2.20

### Breaking changes:

+ Response is not automatically instantiated.

## 2.2.16

+ `deleteCookie` gets `path` parameter

## 2.2.15

+ `deleteCookie` member in `Response`

## 2.2.12

+ `Response` default charset to 'utf-8'

## 2.2.10

+ Added `ExceptionWithResponse`

## 2.2.9

+ Added `onException` method to intercept `Route`

### Breaking changes:

+ Removed `onException` accessor in `Route`
+ Removed generic exception type on `ExceptionHandler`

## 2.2.8

+ Added `before` and `after` methods to intercept `Route`

### Breaking changes:

+ Removed `after` and `before` accessor in `Route`

## 2.2.5

+ Minor bug fix

## 2.2.4

+ Various `ResponseProcessor` utilities

## 2.2.2

+ Serve same server on multiple address.port mappings using `alsoTo`

## 2.2.0

+ Faster routing
+ Powerful `ResponseProcessor`
+ Cleaner `HttpMethod` and `Route` interface
+ Powerful `staticFile` and `staticFiles`

### Breaking changes

+ Removed `RequestHandler`
+ Removed `statusCode`, `mimeType`, `charset` and `headers` from `HttpMethod` and `Route`
+ Renamed `splitPathToSegements` to `pathToSegments`
+ Changed the signature of `ResponseProcessor`

## 2.1.37

+ Dart 2 stable

## 2.1.36

+ Global middleware
+ `Do` has `exec` method for `RequestHandler`s

## 2.1.34

+ Added `accepts` to `Context`
+ Added `acceptsHtml` to `Context`
+ Added `acceptsJson` to `Context`

## 2.1.33

+ Added `mimeType` to `Context`
+ Added `bodyAsMap` to `Context`
+ Added `bodyTo` to `Context`

Breaking changes:
+ `MimeType` is now `MimeTypes`

## 2.1.32

+ `contentType` accessor in `Context`
+ `headers` accessor in `Context`

## 2.1.28

+ Added `strings` constructor to `StreamResponse`

## 2.1.27

+ `Response`'s default charset is 'utf-8'

## 2.1.26

+ `Response.json`'s default charset is 'utf-8'

## 2.1.25

+ `staticFile` fix

## 2.1.24

+ Fixed `bodyAsUrlEncodedForm`

## 2.1.23

+ Fixed bugs in `writeTo`

## 2.1.22

+ Added `writeTo` method to `TextFileFormField` and `BinaryFileFormField`

## 2.1.21

+ Made `MapCoder` an interface
+ `SessionIo` interface

## 2.1.20

+ Separated out `MapCoder` from `CookieSessionManager`

## 2.1.18

+ Added `getString` to `Session`

## 2.1.16

+ Added `getList` and `getSet` methods to `Session`

## 2.1.10

+ Dart2 fixes in `bodyAsFormData`

## 2.1.9

+ `Route` handling bug fix
+ `Route`'s `before`, `after`, `onException` constructor initialization
bug fix

## 2.1.6

+ Moved `Settings` to `jaguar_settings` package

## 1.3.11

+ Fixed `args` package dependency issue

## 1.3.10

+ Work on websockets

## 1.3.9

+ Better JSON decoding and encoding support
+ Mutable `Jaguar` fields

## 1.3.8

+ More stuff for `map`

## 1.3.7

+ Fixed RouteBuilder functions

## 1.3.6

+ Fixed to `map` method in `Muxable`

## 1.3.5

+ RouteBuilder functions
+ Route `map`er for `Muxable`

## 1.3.2

+ Uses Dart 2's void as type to FutureOr in Interceptor return type

## 1.3.1

+ Faster streamlined request handling

## 1.2.10

+ More streamlining of route handlers

## 1.2.9

+ Stream lined request handling
+ Removed global interceptors
+ Removed debug streams

## 1.2.8

+ Added `ResponseProcessor`
+ `Route` now has `responseProcessor` to allow processing response outside handlers
+ `Interceptor.chain` uses `responseProcessor`
+ Added `GetJson`, `PutJson`, `PostJson`, `DeleteJson`, `GetHtml` route annotations
+ JSON route annotations and mux methods now use `responseProcessor`

## 1.2.7

+ `staticFiles` now respects `index.html`

## 1.2.6

+ `Wrap` and `WrapOne` take function or `Symbol` as interceptor creator

## 1.2.2-dev

+ Loosened type of `WrapOne`

## 1.2.1-dev

+ `Wrap` and `WrapOne` take function as interceptor creator
+ `parse` and `write` methods of `SessionManager` takes `Context` instead of `Request`
+ Removed session related methods and fields from `Request`

## 0.7.1

+ Stripped out all mirror dependent elements to `jaguar_reflect`
+ Added `RouteChainSimple` to improve performance
+ Renamed `queryParams` to `query`

## 0.6.27

+ Widened dependency on meta package

## 0.6.27

+ Widened dependency on args package

## 0.6.26

+ Simplified request handling code

## 0.6.25

+ `Context` gets session accessors `session` and `parsedSession`

## 0.6.24

+ Fixed `RouteChain` building issue

## 0.6.23

+ Added `staticFiles` method to `Jaguar` to serve static files!
+ Added `staticFile` method to `Jaguar` to serve a single static file!

### Breaking Changed

+ Renamed `ReflectedRoute` to `RouteChain`
+ Renamed `JaguarReflected` to `ReflectedApi`
+ Renamed `reflectJaguar` to `reflectApi`

## 0.6.22
+ Added `html`, `json`, `getJson`, `putJson`, `postJson`, `deleteJson` methods to `Muxable` and `RouteBuilder`

## 0.6.21

+ Added `socketHandler` to make WebSocket handling easier

## 0.6.20

+ Preserve order of RequestHandlers

## 0.6.19

- Bug fix for `Session`

## 0.6.18

- Sessions are now only written when necessary
- Added HMAC based signing to session data

## 0.6.14

- `Session` in `Request`
- `SessionManager` in `Jaguar` to parse and write session data

## 0.6.13

- `bodyAsText`'s encoding parameter is optional

## 0.6.12

- Upgraded intl dependency

## 0.6.11

- Bootstrapping root APIs using `bootstrap` method
- Supports `package:dice` based DI during bootstrapping

## 0.6.10

- Jaguar shall log only unknown exceptions

## 0.6.9

- Return types of route handlers are now `FutureOr` 

## 0.6.8

- Mux methods now take response members
- Definition of `RouteHandlerFunc`

## 0.6.7

- `wrap` method on `Jaguar`

## 0.6.6

- XML rendering support
- **New error rendering mechanism**
- Debug stream

## 0.6.5

- Merged jaguar_reflect and jaguar_mux into jaguar core

## 0.6.1

- Global interceptors

## 0.6.0

- `Context` based `RequestHandler`

## 0.5.10

- Expose Logger to `Interceptors` and `Routes`
- Configurable `ErrorWriter`

## 0.5.9

- Fixed writing headers to response by `Response`

## 0.5.4

- Added `redirect` to `Response` class

## 0.5.0

- Removed RouteWrapper
- Removed injection

## 0.2.7
- Added properly handling `List<int>` response type
- Implemented Route redirection

## 0.1.14
- Remove Settings from Configuration

## 0.1.13

- Removed isolate creation. Control is given to the programmer.
- Bug fix for "Page not found!" error

## 0.0.3

**Breaking Changes**:

Annotation to build annotation from annotated function has changed.<br>
- `PreProcessorFunction` has changed to `PreInterceptorFunction`
- `PostProcessorFunction` has changed to `PostInterceptorFunction`

`jaguar.yaml` parameters has also changed
- `pre_processors` has changed to `pre_interceptors`
- `post_processors` has changed to `post_interceptors`