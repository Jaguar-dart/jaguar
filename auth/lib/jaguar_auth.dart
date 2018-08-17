// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// This package contains Authenticators and Authorizers for Jaguar
///
/// jaguar_auth provides four types of Authenticators out of the box:
/// 1. [BasicAuth]
/// BasicAuth performs authentication based on
/// [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).
/// It expects base64 encoded "username:password" pair in "authorization" header with
/// "Basic" scheme.
/// 2. [UsernamePasswordAuth]
/// UsernamePasswordAuth expects username and password as 'application/x-www-form-urlencoded'
/// 3. [UsernamePasswordJsonAuth]
/// UsernamePasswordJsonAuthexpects username and password as 'application/json'
///
/// jaguar_auth provides an authorizer: [Authorizer]
library jaguar_auth;

export 'authenticators/authenticators.dart';
export 'authorizer/authorizer.dart';
export 'hasher/hasher.dart';
