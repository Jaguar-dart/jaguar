library jaguar.http.json;

abstract class ToJsonable {
  String toJson();
}

abstract class FromJsonable {
  void fromJson(String json);
}

abstract class Jsonable implements ToJsonable, FromJsonable {}
