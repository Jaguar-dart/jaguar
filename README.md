# Jaguar

Jaguar is a server-side framework which use annotation and code generation to help
you to be productive and focus only on your code.

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
  @Group()
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

## Advenced Api

You can create PreProcessor and PostProcessor with `PreProcessorFunction` and `PostProcessorFunction`

For doing that you just have to write a simple function and annotated it with the `PreProcessorFunction` to create a PreProcessor or `PostProcessorFunction` to create a PostProcessor.

### PreProcessor

```dart
@PreProcessorFunction(
    authorizedMethods: const <String>['POST', 'PUT', 'PATCH', 'DELETE'])
void mustBeMimeType(HttpRequest request, String mimeType) {
  if (request.headers.contentType?.mimeType != mimeType) {
    throw "Mime type is ${request.headers.contentType?.mimeType} instead of $mimeType";
  }
}
```

Here we have write a PreProcessor that check the content type of the request on the authorized methods.

There is a rules for the arguments !

You can ask for the request object by putting this arguments inside the needed arguments.

Arguments with the variable name which start with an _ are not modified so you can ask for a specific variable.

Argument which doesn't start with _ are argument needed by your function and have to be specified in the annotation

In our example above the framework will auto inject the request and the mimeType will be get from the annotation.
