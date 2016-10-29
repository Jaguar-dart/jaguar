library jaguar.src.utils.string;

int stringToInt(String value, {int defaultValue: 0}) {
  if(value is! String) {
    return defaultValue;
  }

  return int.parse(value, onError: (_) => defaultValue);
}

double stringToDouble(String value, {double defaultValue: 0.0}) {
  if(value is! String) {
    return defaultValue;
  }

  return double.parse(value, (_) => defaultValue);
}

bool stringToBool(String value, {bool defaultValue: false}) {
  if(value is! String) {
    return defaultValue;
  }

  if(value == "true") {
    return true;
  } else if(value == "false") {
    return false;
  }

  return defaultValue;
}