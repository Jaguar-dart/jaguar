library jaguar.generator.utils;

String getTypeFromFuture(String returnType) {
  RegExp regExp = new RegExp("^Future<([A-Za-z, <>]+)>\$");
  Iterable<Match> matchs = regExp.allMatches(returnType);
  if (matchs.isEmpty) {
    return "dynamic";
  }
  return matchs.first.group(1);
}
