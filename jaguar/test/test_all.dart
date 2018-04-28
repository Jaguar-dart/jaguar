library jaguar.test_all;

import 'data/body_json.dart' as dataBodyJson;
import 'data/cookie.dart' as dataCookie;
import 'data/path_params.dart' as dataPathParams;
import 'data/query_params.dart' as dataQueryParams;

import 'interceptor/after/after.dart' as interceptAfter;
import 'interceptor/before/before.dart' as interceptBefore;
import 'interceptor/exception/exception.dart' as interceptException;

import 'mux/mux.dart' as mux;

import 'response/json/json.dart' as responseJson;
import 'response/stream/stream.dart' as responseStream;

import 'settings/settings.dart' as settings;

import 'websocket/websocket.dart' as websocket;

void main() {
  dataBodyJson.main();
  dataCookie.main();
  dataPathParams.main();
  dataQueryParams.main();

  interceptAfter.main();
  interceptBefore.main();
  interceptException.main();

  mux.main();

  responseJson.main();
  responseStream.main();

  settings.main();

  websocket.main();
}
