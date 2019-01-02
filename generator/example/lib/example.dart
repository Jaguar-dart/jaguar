import 'package:jaguar/jaguar.dart';

part 'example.jroutes.dart';

@GenController(path: "/simple")
class SimpleApi extends Controller with _$SimpleApi {
  @Get()
  String get(_) => "simple";

  @IncludeController(path: '/include')
  final include = IncludeApi();
}

@GenController(path: "/include")
class IncludeApi extends Controller with _$IncludeApi {
  @HttpMethod(
      methods: ['UP'],
      statusCode: 201,
      responseProcessor: jsonResponseProcessor)
  Future<List<int>> upIt(_) async => [1, 2, 3];
}
