library jaguar.http.json;

abstract class ToJsonable {
  Map toJson();
}

abstract class FromJsonable {
  void fromJson(Map json);
}

abstract class Jsonable implements ToJsonable, FromJsonable {}
