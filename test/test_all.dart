library jaguar.test_all;

import 'jaguar/exception/exception.dart' as exceptionExcept;
import 'jaguar/include_api/main.dart' as includeApi;
import 'jaguar/interceptor/custom_interceptor/custom_interceptor.dart'
    as customInterceptor;
import 'jaguar/interceptor/inject_input/inject_input.dart' as injectInput;
import 'jaguar/route/route.dart' as route;

import 'request/decode_body/json/json.dart' as decodeJson;
import 'request/query_params/query_params.dart' as queryParams;

import 'response/json/json.dart' as responseJson;
import 'response/stream/stream.dart' as responseStream;

import 'settings/settings.dart' as settings;

import 'websocket/websocket.dart' as websocket;

import 'bootstrap/serve.dart' as bootstrap;

void main() {
  exceptionExcept.main();
  includeApi.main();
  customInterceptor.main();
  injectInput.main();
  route.main();

  decodeJson.main();
  queryParams.main();

  responseJson.main();
  responseStream.main();

  settings.main();

  websocket.main();

  bootstrap.main();
}
