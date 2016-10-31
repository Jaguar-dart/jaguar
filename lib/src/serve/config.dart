part of jaguar.src.serve;

//Structure to configure Jaguar
class Configuration {
  final String address;
  final int port;
  final SecurityContext securityContext;
  final bool multiThread;
  final bool log;
  List<dynamic> apis = <dynamic>[];

  Configuration(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.securityContext: null,
      this.log: false});

  void addApi(dynamic apiClass) {
    apis.add(apiClass);
  }

  String get protocolStr => securityContext == null ? 'http' : 'https';

  String get baseUrl {
    return "$protocolStr://$address:$port/";
  }
}
