library jaguar_generator.validator;

import 'package:jaguar_generator/parser/parser.dart';
import 'package:jaguar_generator/common/validator.dart';

part 'interceptor.dart';

class ValidatorOfGroup implements Validator {
  ParsedGroup group;

  void validate() {
    //TODO check that type implements RequestHandler
    //TODO make sure that there is only one group annotation
  }
}

class ValidatorUpper implements Validator {
  ParsedUpper upper;

  ValidatorUpper(this.upper);

  void validate() {}
}
