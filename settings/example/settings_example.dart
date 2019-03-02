import 'package:jaguar_settings/jaguar_settings.dart';

class Config {
  String port;

  String authSalt;

  bool prod;
}

main(List<String> args) {
  Settings.parse(args);
}
