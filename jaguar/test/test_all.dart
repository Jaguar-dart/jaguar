library jaguar.test_all;

import 'body/body_json.dart' as dataBodyJson;
import 'body/cookie.dart' as dataCookie;
import 'body/path_params.dart' as dataPathParams;
import 'body/query_params.dart' as dataQueryParams;

import 'interceptor/after/after.dart' as interceptAfter;
import 'interceptor/before/before.dart' as interceptBefore;
import 'interceptor/exception/exception.dart' as interceptException;

import 'mux/mux.dart' as mux;

import 'response/json/json.dart' as responseJson;
import 'response/stream/stream.dart' as responseStream;

import 'serve/restart.dart' as serverRestart;

import 'session/session.dart' as session;

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

  serverRestart.main();

  session.main();

  websocket.main();
}
