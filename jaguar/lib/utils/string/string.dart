library jaguar.src.utils.string;

int? stringToInt(String? value, [int? defaultValue]) {
  if (value == null) {
    return defaultValue;
  }

  return int.tryParse(value) ?? defaultValue;
}

double? stringToDouble(String? value, [double? defaultValue]) {
  if (value == null) {
    return defaultValue;
  }

  return double.tryParse(value) ?? defaultValue;
}

num? stringToNum(String? value, [num? defaultValue]) {
  if (value == null) {
    return defaultValue;
  }

  return num.tryParse(value) ?? defaultValue;
}

bool? stringToBool(String? value, [bool? defaultValue]) {
  if (value == null) {
    return defaultValue;
  }

  if (value == "true") {
    return true;
  } else if (value == "false") {
    return false;
  }

  return defaultValue;
}
