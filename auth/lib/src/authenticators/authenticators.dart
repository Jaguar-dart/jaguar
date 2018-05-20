/// jaguar_auth provides three types of Authenticators out of the box:
/// 1. [BasicAuth]
/// BasicAuth performs authentication based on
/// [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).
/// It expects base64 encoded "username:password" pair in "authorization" header with
/// "Basic" scheme.
/// 2. [FormAuth]
/// UsernamePasswordAuth expects username and password as 'application/x-www-form-urlencoded'
/// 3. [JsonAuth]
/// UsernamePasswordJsonAuthexpects username and password as 'application/json'
library jaguar_auth.authenticators;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_auth/src/entity/entity.dart';
import 'package:jaguar_auth/src/hasher/hasher.dart';

part 'basic_auth.dart';
part 'form_auth.dart';
part 'json_auth.dart';
