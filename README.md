# Jaguar

Jaguar is a server-side framework which use annotation and code generation to help
you to be productive and focus only on your code.

## How to use it

Clone this repos go inside you project folder and launch the jaguar.dart script with the param build or watch

The build param will build you server you have to launch it after this step.

The watch param will watch your modification, build after it and launch you server every time you change you server.

In order to build your server the jaguar script need some configuration file.

You have an example in this repos jaguar.yaml

This file define two things
- The name of the file which launch your server.
```yaml
bin:
  'bin/server.dart'
```

- A list of file where you have `@Api` annotation.<br>
```yaml
apis:
  - 'example/api.dart'
```

- A list of file where you have `@PreProcessor` annotation.<br>

- A list of file where you have `@PostProcessor` annotation.<br>

The entire file of the example code is [here](https://github.com/Jaguar-dart/jaguar/blob/master/jaguar.yaml)

Ok now how to create a jaguar server we have to writte.

Here a basic example
```dart
import 'dart:async';

import 'package:jaguar/jaguar.dart' as jaguar;

import 'api.dart';

Future<Null> main(List<String> args) async {
  ExampleApi tsa = new ExampleApi();

  jaguar.Configuration configuration =
      new jaguar.Configuration();
  configuration.addApi(tsa);

  await jaguar.serve(configuration);
}
```

We create the class we have in the api.dart file, create a configuration object which will configure our jaguar server.

And serve with the configuration object.

Easy !

## Basic API

Jaguar has 3 type processor built-in.
A processor is an annotation which define your api, group and route.

### Api

The Api annotation is the first annotation you need to use in order to create a jaguar server.

```dart
import 'package:jaguar/jaguar.dart';

@Api()
class ExampleApi extends _$JaguarExampleApi {}
```

Let's see what is there:

- we import jaguar
- we use the Api annotation to tell to jaguar generate the associated code for the ExampleApi class.
- the generated code will be in the `_$JaguarExampleApi` abstract class
(note: the generated class is named with `_$Jaguar` plus the name of your class)

### Group

The Group annotation allows you to create group of request (e.g: for your resources)

```dart
import 'package:jaguar/jaguar.dart';

class UsersResource {}

@Api()
class ExampleApi extends _$JaguarExampleApi {
  @Group(name: 'users')
  UsersResource users = new UsersResource();
}
```

What do we have now.

- we have the group annotation that allows you to define new route inside the UsersResource class
- users is a field with a UsersResource object

### Route

The Route annotation allows you to define a route on your server

It takes two named parameters
- path to define the uri of your route
- the allowed methods on this route

```dart
import 'package:jaguar/jaguar.dart';

class UsersResource {
  @Route(path: 'users/name', methods: <String>['GET'])
  List<String> getNames() {
    return ["Henri", "Jacques"];
  }
}

@Api()
class ExampleApi extends _$JaguarExampleApi {
  @Route(path: 'ping', methods: const <String>['GET'])
  String ping() {
    return "pong";
  }

  @Group()
  UsersResource users = new UsersResource();
}
```

With your route you can return all sort of object.

The default behavior is to call `toString` on your object to put it in the response

## Advanced Api

You can create PreProcessor and PostProcessor with `PreProcessorFunction` and `PostProcessorFunction`

For doing that you just have to write a simple function and annotated it with the `PreProcessorFunction` to create a PreProcessor or `PostProcessorFunction` to create a PostProcessor.

There are rules for the arguments !

You can ask for the request object by putting this arguments inside the needed arguments.

Arguments with the variable name which start with an _ are not modified so you can ask for a specific variable.

Argument which doesn't start with _ are argument needed by your function and have to be specified in the annotation

Another special case happend when you request the variable result.<br/>
When you ask for this one you will get the result of your Route.

If you add a PreProcessor or a PostProcessor to a `@Group` or an `@Api` this annotation will be added to all the children.

### PreProcessor

```dart
@PreProcessorFunction(
  authorizedMethods: const <String>['POST', 'PUT', 'PATCH', 'DELETE'])
void mustBeMimeType(HttpRequest request, String mimeType) {
  if (request.headers.contentType?.mimeType != mimeType) {
    throw
      "Mime type is ${request.headers.contentType?.mimeType} instead of $mimeType";
  }
}
```

Here we have write a PreProcessor that check the content type of the request on the authorized methods.

In our example above the framework will auto inject the request and the mimeType will be get from the annotation.

### PostProcessor

```dart
@PostProcessorFunction(takeResponse: true)
void encodeStringToJson(HttpRequest request, String result) {
  int length = UTF8.encode(result).length;
  request.response
    ..headers.contentType = new ContentType("application", "json")
    ..contentLength = length
    ..write(result);
}
```

In this example we ask for the request and the result.

result is a special variable name that will return to you the object you have return in your route.

In the annotation here we have the `takeResponse` argument which is false by default, this argument allow you to tell to the framework that you are responsible for sending the response.

## The State of Jaguar

Jaguar is under development and feedback are welcome.

## What more

- Add test
- More built-in Post/Pre Processor
- More check during generation.

## Issue

If you have an issue please tell us which version of jaguar and if you can provide an example this will simplify the path to resolve it :).
