part of jaguar_generator.validator;

class NoPrePost implements Validator {
  final String interceptor;

  NoPrePost(this.interceptor);

  void validate() {
    /* TODO
    try {
      // check such method exists
      MethodElementWrap meth = upper.methods.singleWhere(
              (MethodElementWrap m) => m.name == MirrorSystem.getName(sym));

      // check that the method returns Interceptor
      if(!meth.returnTypeWithoutFuture.isSubTypeOfNamedElement(kTypeInterceptor)) {
        throw new Exception("'Interceptor creator method' $sym does not return 'Interceptor'!");
      }

      // Check that it has only one required argument
      // TODO

      // Check that the required argument is Context
      // TODO
    } catch (e) {
      throw new Exception("'Interceptor creator method' $sym not found!");
    }
    */
  }
}
