[![Pub](https://img.shields.io/pub/v/jaguar.svg)](https://pub.dartlang.org/packages/jaguar)
[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)
[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/jaguar_dart/jaguar)

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

### Easily define and access Path parameters

Path segments prefixed with `:` can match any value and are also captured as path variables. Path variables can be accessed
using `pathParams` member of `Context` object.

```dart
main(List<String> args) async {
  final quotes = <String>[
    'But man is not made for defeat. A man can be destroyed but not defeated.',
    'When you reach the end of your rope, tie a knot in it and hang on.',
    'Learning never exhausts the mind.',
  ];

  final server = new Jaguar();
  server.get('/api/quote/:index', (ctx) { // The magic!
    final int index = ctx.pathParams.getInt('index', 1);  // The magic!
    return quotes[index + 1];
  });
  await server.serve();
}
```

+ A path can have multiple path variables.
+ A path variable can appear at any position in the path.
+ A path variable can be matched against a Regular expression.
+ `getInt`, `getDouble`, `getNum` and `getBool` methods can be used to easily typecast path variables.
+ Using * as the final path segment captures/matches all following segments.

## Easily access Query parameters

Query parameters can be accessed using `queryParams` member of `Context` object.

```dart
main(List<String> args) async {
  final quotes = <String>[
    'But man is not made for defeat. A man can be destroyed but not defeated.',
    'When you reach the end of your rope, tie a knot in it and hang on.',
    'Learning never exhausts the mind.',
  ];

  final server = new Jaguar();
  server.get('/api/quote', (ctx) {
    final int index = ctx.queryParams.getInt('index', 1); // The magic!
    return quotes[index + 1];
  });
  await server.serve();
}
```

`getInt`, `getDouble`, `getNum` and `getBool` methods can be used to easily typecast query parameters into desired type.

## One liner to access Forms

A single line is all it takes to obtain a form as a `Map<String, String>` using method [`bodyAsUrlEncodedForm`][Doc::Request::bodyAsUrlEncodedForm] 
on [`Request`][Doc::Request] object.

```dart
main(List<String> arguments) async {
  final server = new Jaguar(port: 8005);

  server.post('/api/add', (ctx) async {
      final Map<String, String> map = await ctx.req.bodyAsUrlEncodedForm(); // The magic!
      contacts.add(Contact.create(map));
      return Response.json(contacts.map((ct) => ct.toMap).toList());
    });


  await server.serve();
}
```

## One liner to serve static files

The method [`staticFiles`][Doc::Jaguar::staticFiles] adds static files to `Jaguar` server. The first argument determines
the request Uri that much be matched and the second argument determines the directory from which the target files are fetched.

```dart
main() async {
  final server = new Jaguar();
  server.staticFiles('/static/*', 'static'); // The magic!
  await server.serve();
}
```

## JSON serialization with little effort

Decoding JSON requests can't be simpler than using one of the built-in [`bodyAsJson`][Doc::Request::bodyAsJson], 
[`bodyAsJsonMap`][Doc::Request::bodyAsJsonMap] or [`bodyAsJsonList`][Doc::Request::bodyAsJsonList] methods on 
[`Request`][Doc::Request] object.

```dart
Future<Null> main(List<String> args) async {
  final server = new Jaguar();
  server.post('/api/book', (Context ctx) async {
    // Decode request body as JSON Map
    final Map<String, dynamic> json = await ctx.req.bodyAsJsonMap();
    Book book = new Book.fromMap(json);
    // Encode Map to JSON
    return Response.json(book.toMap());
  });

  await server.serve();
}
```

## Out-of-the-box Sessions support

```dart
main() async {
  final server = new Jaguar();
  server.get('/api/add/:item', (ctx) async {
    final Session session = await ctx.req.session;
    final String newItem = ctx.pathParams.item;

    final List<String> items = (session['items'] ?? '').split(',');

    // Add item to shopping cart stored on session
    if (!items.contains(newItem)) {
      items.add(newItem);
      session['items'] = items.join(',');
    }

    return Response.redirect('/');
  });
  server.get('/api/remove/:item', (ctx) async {
    final Session session = await ctx.req.session;
    final String newItem = ctx.pathParams.item;

    final List<String> items = (session['items'] ?? '').split(',');

    // Remove item from shopping cart stored on session
    if (items.contains(newItem)) {
      items.remove(newItem);
      session['items'] = items.join(',');
    }

    return Response.redirect('/');
  });
  await server.serve();
}
```

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

[Doc::Jaguar]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Jaguar-class.html
[Doc::Jaguar::get]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/get.html
[Doc::Jaguar::delete]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/delete.html
[Doc::Jaguar::post]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/post.html
[Doc::Jaguar::put]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/put.html
[Doc::Jaguar::options]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/options.html
[Doc::Jaguar::staticFiles]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Muxable/staticFiles.html
[Doc::Request]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Request-class.html
[Doc::Request::bodyAsJson]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Request/bodyAsJson.html
[Doc::Request::bodyAsJsonMap]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Request/bodyAsJsonMap.html
[Doc::Request::bodyAsJsonList]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Request/bodyAsJsonList.html
[Doc::Request::bodyAsUrlEncodedForm]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Request/bodyAsUrlEncodedForm.html