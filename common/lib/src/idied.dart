library jaguar_common.idied;

/// Interface to require that Model must contain an Id
abstract class Idied<T> {
  T get id;

  set id(T value);
}
