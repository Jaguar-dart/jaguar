[![Pub](https://img.shields.io/pub/v/jaguar.svg)](https://pub.dartlang.org/packages/jaguar)
[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)
[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/jaguar_dart/jaguar)

# Jaguar

Jaguar is a full-stack production ready HTTP server framework built to be fast, simple and intuitive.

# Getting started

## Familiar way to write routes

[`Jaguar`][Doc::Jaguar] class provides methods [`get`][Doc::Jaguar::get], [`put`][Doc::Jaguar::put], [`post`][Doc::Jaguar::post], 
[`delete`][Doc::Jaguar::delete] and [`options`][Doc::Jaguar::options] to quickly add route handlers for specific HTTP methods.

```dart
main() async {
  final server = Jaguar();  // Serves the API at localhost:8080 by default
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

  final server = Jaguar();
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

  final server = Jaguar();
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
  final server = Jaguar(port: 8005);

  server.postJson('/api/add', (ctx) async {
      final Map<String, String> map = await ctx.req.bodyAsUrlEncodedForm(); // The magic!
      contacts.add(Contact.create(map));
      return contacts.map((ct) => ct.toMap).toList();
    });


  await server.serve();
}
```

## One liner to serve static files

The method [`staticFiles`][Doc::Jaguar::staticFiles] adds static files to `Jaguar` server. The first argument determines
the request Uri that much be matched and the second argument determines the directory from which the target files are fetched.

```dart
main() async {
  final server = Jaguar();
  server.staticFiles('/static/*', 'static'); // The magic!
  await server.serve();
}
```

## JSON serialization with little effort

Decoding JSON requests can't be simpler than using one of the built-in [`bodyAsJson`][Doc::Request::bodyAsJson], 
[`bodyAsJsonMap`][Doc::Request::bodyAsJsonMap] or [`bodyAsJsonList`][Doc::Request::bodyAsJsonList] methods on 
[`Request`][Doc::Request] object.

```dart
Future<void> main(List<String> args) async {
  final server = Jaguar();
  server.postJson('/api/book', (Context ctx) async {
    // Decode request body as JSON Map
    final Map<String, dynamic> json = await ctx.req.bodyAsJsonMap();
    Book book = Book.fromMap(json);
    return book; // Automatically encodes Book to JSON
  });

  await server.serve();
}
```

## Out-of-the-box Sessions support

```dart
main() async {
  final server = Jaguar();
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
