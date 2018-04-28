library jaguar.example.routes.simple;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

part 'simple.g.dart';

class SampleInterceptor extends FullInterceptor {
  final String id;

  SampleInterceptor(this.id);

  Null output;

  void before(Context ctx) {
    print('Simple interceptor pre with id $id is called!');
  }

  Response after(Context ctx, Response incoming) {
    print('Simple interceptor post with id $id is called!');
    return incoming;
  }
}

class ExceptHandler implements ExceptionHandler {
  const ExceptHandler();

  @override
  Response onRouteException(Context ctx, e, StackTrace trace) {
    print(e);
    return null;
  }
}

SampleInterceptor sampleInterceptor2(Context ctx) => new SampleInterceptor('2');

/// Example of basic API class
@Api()
class SubGroup extends _$JaguarSubGroup {
  static SampleInterceptor sampleInterceptor(Context ctx) =>
      new SampleInterceptor('1');

  SampleInterceptor sampleInterceptor3(Context ctx) =>
      new SampleInterceptor('3');

  /// Example of basic route
  @Route(path: '/ping')
  @ExceptHandler()
  @WrapOne(sampleInterceptor)
  @WrapOne(sampleInterceptor2)
  @WrapOne(#sampleInterceptor3)
  Future<String> normal(Context ctx) async => "You pinged me!";

  @Put(path: '/void')
  void voidRoute(Context ctx) {}

  @Put(path: '/map/empty')
  Future<Response<String>> jsonRoute(Context ctx) async => Response.json({});
}

/// Example of basic API class
@Api(path: '/api')
class MotherGroup extends _$JaguarMotherGroup {
  /// Example of basic route
  @Route(path: '/ping')
  String ping(Context ctx) => "You pinged me!";

  @IncludeApi(path: '/sub')
  final SubGroup subGroup = new SubGroup();
}

main() async {
  final server = new Jaguar();
  server.addApi(new MotherGroup());
  await server.serve();
}
