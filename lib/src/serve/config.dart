part of jaguar.src.serve;

//Structure to configure Jaguar
class Configuration {
  final String address;
  final int port;
  final SecurityContext securityContext;
  final bool multiThread;
  final bool log;
  List<RequestHandler> apis = <RequestHandler>[];

  Map<String, String> _settings;
  List<String> _args;

  Configuration(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.securityContext: null,
      this.log: false,
      List<String> args: const []})
      : _args = args {
    _settings = {};
  }

  void addApi(RequestHandler clazz) {
    apis.add(clazz);
  }

  String get protocolStr => securityContext == null ? 'http' : 'https';

  String get baseUrl {
    return "$protocolStr://$address:$port/";
  }

  void addSettings(Map<String, String> map) {
    _settings.addAll(map);
  }

  Future instanciateSettings() => Settings.parse(_args, _settings);
}
