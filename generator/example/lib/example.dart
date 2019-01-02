import 'package:jaguar/jaguar.dart';

part 'example.jroutes.dart';

@GenController(path: "/simple")
class SimpleApi extends Controller with _$SimpleApi {
  @Get()
  String get(_) => "simple";
}