part of jaguar.generator.parser.interceptor;

class InterceptorFuncInfo implements InterceptorInfo {
  InterceptorFuncDef definition;

  bool isPost;

  DartType result;

  List<Input> inputs = <Input>[];

  bool writesResponse;

  bool shouldKeepQueryParam;

  InterceptorFuncInfo(this.definition, {this.isPost: false});
}
