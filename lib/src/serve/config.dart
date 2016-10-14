part of jaguar.src.serve;

//Structure to configure Jaguar
class Configuration {
  final String address;
  final int port;
  final SecurityContext context;
  final bool multiThread;
  List<dynamic> apis;

  Configuration(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.context: null}) {
    apis = <dynamic>[];
  }

  void addApi(dynamic apiClass) {
    apis.add(apiClass);
  }

  String get protocolStr => context == null ? 'http': 'https';

  String get baseUrl {
    return "$protocolStr://$address:$port/";
  }
}
