part of jaguar.src.serve;

//Structure to configure Jaguar
class Configuration {
  final String address;
  final int port;
  final SecurityContext securityContext;
  final bool multiThread;
  final bool log;
  List<HandleRequestInterface> apis = <HandleRequestInterface>[];

  Configuration(
      {this.address: "0.0.0.0",
      this.port: 8080,
      this.multiThread: false,
      this.securityContext: null,
      this.log: false});

  void addApi(HandleRequestInterface clazz) {
    apis.add(clazz);
  }

  String get protocolStr => securityContext == null ? 'http' : 'https';

  String get baseUrl {
    return "$protocolStr://$address:$port/";
  }
}
