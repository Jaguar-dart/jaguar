library jaguar_auth.hasher;

import "package:crypto/crypto.dart" as Crypto;

abstract class Hasher {
  String hash(String password);

  /// Verifies the given password with given hash
  bool verify(String hashed, String unhashed);
}

class NoHasher implements Hasher {
  const NoHasher();

  String hash(String password) => password;

  /// Verifies the given password with given hash
  bool verify(String hashed, String unhashed) => hashed == unhashed;
}

/// Password hasher
class MD5Hasher implements Hasher {
  final String salt;

  const MD5Hasher(this.salt);

  String hash(String password) {
    String saltedPassword = password + salt;
    Crypto.Digest digest = Crypto.md5.convert(saltedPassword.codeUnits);
    return digest.toString();
  }

  /// Verifies the given password with given hash for the given salt
  bool verify(String hashed, String unhashed) {
    return hashed == hash(unhashed);
  }
}

/// Password hasher
class Sha1Hasher implements Hasher {
  final String salt;

  const Sha1Hasher(this.salt);

  String hash(String unhashed) {
    String saltedPassword = unhashed + salt;
    Crypto.Digest digest = Crypto.sha1.convert(saltedPassword.codeUnits);
    return digest.toString();
  }

  /// Verifies the given password with given hash for the given salt
  bool verify(String hashed, String unhashed) {
    return hashed == hash(unhashed);
  }
}

/// Sha256 hasher
class Sha256Hasher implements Hasher {
  /// Salt for hasher
  final String salt;

  const Sha256Hasher(this.salt);

  String hash(String unhashed) {
    String saltedPassword = unhashed + salt;
    Crypto.Digest digest = Crypto.sha256.convert(saltedPassword.codeUnits);
    return digest.toString();
  }

  /// Verifies the given password with given hash for the given salt
  bool verify(String hashed, String unhashed) {
    return hashed == hash(unhashed);
  }
}
