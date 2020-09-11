library jaguar.test_all;

import 'body/body_json_test.dart' as bodyJson;
import 'body/cookie_test.dart' as bodyCookie;
import 'body/form_data_test.dart' as bodyFormData;
import 'body/path_params_test.dart' as bodyPathParams;
import 'body/query_params_test.dart' as bodyQueryParams;
import 'body/url_encoded_form_test.dart' as bodyUrlEncodedForm;

import 'interceptor/after/after_test.dart' as interceptAfter;
import 'interceptor/before/before_test.dart' as interceptBefore;
import 'interceptor/exception/exception_test.dart' as interceptException;

import 'mux/mux_test.dart' as mux;

import 'response/json/json_test.dart' as responseJson;
import 'response/stream/stream_test.dart' as responseStream;
import 'response/empty.dart' as responseEmpty;

import 'serve/restart_test.dart' as serverRestart;

import 'session/session_test.dart' as session;

import 'static_file/static_files_tests.dart' as staticFiles;

import 'websocket/websocket_test.dart' as websocket;

void main() {
  bodyJson.main();
  bodyCookie.main();
  bodyFormData.main();
  bodyPathParams.main();
  bodyQueryParams.main();
  bodyUrlEncodedForm.main();

  interceptAfter.main();
  interceptBefore.main();
  interceptException.main();

  mux.main();

  responseJson.main();
  responseStream.main();
  responseEmpty.main();

  serverRestart.main();

  session.main();

  staticFiles.main();

  websocket.main();
}
