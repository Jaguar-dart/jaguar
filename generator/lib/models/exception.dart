part of jaguar_generator.models;

class ExceptionHandler {
  final String handlerName;

  final String _instantiationString;

  String get instantiationString => 'new ' + _instantiationString;

  ExceptionHandler(this.handlerName, this._instantiationString);
}
