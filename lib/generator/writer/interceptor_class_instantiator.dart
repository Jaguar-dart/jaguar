part of jaguar.generator.writer;

class InterceptorClassDecl {
  /// Route of the interceptor
  final RouteInfo _r;

  /// Interceptor for which instantiation code is being generated
  final InterceptorClassInfo _i;

  /// String buffer to write the result to
  StringBuffer _w = new StringBuffer();

  InterceptorClassDecl(this._r, this._i) {
    _generate();
  }

  void _generate() {
    _w.write(_i.instantiationString);
  }

  String get code => _w.toString();
}