[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)

# Jaguar

Jaguar is a production ready HTTP server framework built for **speed, simplicity and extensiblity**

# Getting started

## Familiar way to write routes

[`Jaguar`][Doc::Jaguar] class provides methods [`get`][Doc::Jaguar::get], [`put`][Doc::Jaguar::put], [`post`][Doc::Jaguar::post], 
[`delete`][Doc::Jaguar::delete] and [`options`][Doc::Jaguar::options] to quickly add route handlers for specific HTTP methods at 
desired path to the server.

```dart
main() async {
  final server = new Jaguar();  // Serves the API at localhost:8080 by default
  // Add a route handler for 'GET' method at path '/hello'
  server.get('/hello', (Context ctx) => 'Hello world!');
  await server.serve();
}
```

## Powerful route matching

> TODO

## Easily access Query and Path parameters

> TODO

## One liner to access Forms

> TODO

## One liner to serve static files

The method [`staticFiles`][Doc::Jaguar::staticFiles] adds static files to `Jaguar` server. The first argument determines
the request Uri that much be matched and the second argument determines the directory from which the target files are fetched.

```dart
  final server = new Jaguar();
  server.staticFiles('/static/*', 'static'); // The magic!
  await server.serve();
```

## JSON serialization with little effort

> TODO

## One liners to encode JSON response

> TODO

## Organise route handlers in an API class

> TODO

## Session support

> TODO

## Authentication support

> TODO

## Mongo support

> TODO

## ORM support for SQL databases

> TODO

# Advantages of Jaguar

1. Batteries included
    1. Database
        1. [Fluent query builder](https://github.com/Jaguar-dart/jaguar_query)
        2. [ORM](https://github.com/Jaguar-dart/jaguar_orm)
        3. Migration support
        3. Various databases support
            1. [Mongo](https://github.com/Jaguar-dart/jaguar_mongo)
            2. [PostgreSQL](https://github.com/Jaguar-dart/jaguar_postgresql) ([Query](https://github.com/Jaguar-dart/jaguar_query_postgresql))
            3. [MySQL](https://github.com/Jaguar-dart/jaguar_sqljocky) ([Query](https://github.com/Jaguar-dart/jaguar_query_sqljocky))
            4. OracleDB
            5. MS SQL
    3. [Authentication and Authorization](https://github.com/Jaguar-dart/jaguar_auth)
    4. [OAuth](https://github.com/Jaguar-dart/jaguar_oauth)
    5. [Session management](https://github.com/Jaguar-dart/jaguar_session)
2. Build your routes the way you prefer
    1. Controller based
        1. Reflect
        2. Generate
    2. Mux based
3. [Extensible interceptor infrastructure](https://github.com/Jaguar-dart/jaguar/wiki/Interceptor)
4. [Extensive respository of examples](https://github.com/Jaguar-examples)
    1. [Annotation based](https://github.com/jaguar-examples/boilerplate)
    2. [Reflection based](https://github.com/jaguar-examples/boilerplate_reflect)
    3. [Mux based](https://github.com/jaguar-examples/boilerplate_mux)
    4. [MongoDB](https://github.com/jaguar-examples/boilerplate_mongo)
    5. [PostgreSQL](https://github.com/jaguar-examples/boilerplate_postgresql)
    6. [MySQL](https://github.com/jaguar-examples/boilerplate_sqljocky)
    7. [Upload files using Jaguar](https://github.com/jaguar-examples/upload_file)

## Join us on Gitter

- [jaguar](https://gitter.im/jaguar_dart/jaguar)
- [dart server](https://gitter.im/dart-lang/server)

[Doc::Jaguar]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Jaguar-class.html
[Doc::Jaguar::get]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/get.html
[Doc::Jaguar::delete]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/delete.html
[Doc::Jaguar::post]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/post.html
[Doc::Jaguar::put]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/put.html
[Doc::Jaguar::options]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/options.html
[Doc::Jaguar::staticFiles]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/staticFiles.html