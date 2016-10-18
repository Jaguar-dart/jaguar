part of jaguar.generator.info;

class GroupInfo {
  final ant.Group group;

  GroupInfo(this.group);
}

ant.Group parseGroup(Element element) {
  return element.metadata
      .map((ElementAnnotation annot) => instantiateAnnotation(annot))
      .firstWhere((dynamic instance) => instance is ant.Group, orElse: null);
}

List<RouteInfo> collectAllRoutes(ClassElement classElement, String prefix,
    List<InterceptorInfo> interceptorsParent) {
  List<RouteInfo> routes =
      collectRoutes(classElement, prefix, interceptorsParent);

  classElement.fields
      .map((FieldElement field) {
        ant.Group group = parseGroup(field);

        if (field == null) {
          return null;
        }

        return collectAllRoutes(
            field.type.element, "$prefix/${group.name}", interceptorsParent);
      })
      .where((List<RouteInfo> routes) => routes != null)
      .forEach((List<RouteInfo> val) => routes.addAll(val));

  return routes;
}
