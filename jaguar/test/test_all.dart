library jaguar.test_all;

import 'body/body_json_test.dart' as bodyJson;
import 'body/cookie_test.dart' as bodyCookie;
import 'body/form_data_test.dart' as bodyFormData;
import 'body/path_params_test.dart' as bodyPathParams;
import 'body/query_params_test.dart' as bodyQueryParams;
import 'body/url_encoded_form_test.dart' as bodyUrlEncodedForm;

import 'headers/modified.dart' as headersModified;
import 'headers/unmodified.dart' as headersUnmodified;

import 'interceptor/after/after_test.dart' as interceptAfter;
import 'interceptor/before/before_test.dart' as interceptBefore;
import 'interceptor/exception/exception_test.dart' as interceptException;

import 'mux/mux_test.dart' as mux;

import 'response/json/json_test.dart' as responseJson;
import 'response/stream/stream_test.dart' as responseStream;

import 'serve/restart_test.dart' as serverRestart;

import 'session/session_test.dart' as session;

import 'websocket/websocket_test.dart' as websocket;

void main() {
  bodyJson.main();
  bodyCookie.main();
  bodyFormData.main();
  bodyPathParams.main();
  bodyQueryParams.main();
  bodyUrlEncodedForm.main();

  headersModified.main();
  headersUnmodified.main();

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
