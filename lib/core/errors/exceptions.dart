class ServerException implements Exception {
  final String message;
  const ServerException({
    this.message = 'An unexpected server error occurred.',
  });
  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'An unexpected cache error occurred.'});
  @override
  String toString() => 'CacheException: $message';
}

class InvalidCredentialsException extends ServerException {
  const InvalidCredentialsException({
    super.message = 'Invalid email or password.',
  });
}

class UserNotFoundException extends ServerException {
  const UserNotFoundException({
    super.message = 'No user found for that email.',
  });
}

class WrongPasswordException extends ServerException {
  const WrongPasswordException({
    super.message = 'Wrong password provided for that user.',
  });
}

class EmailAlreadyInUseException extends ServerException {
  const EmailAlreadyInUseException({
    super.message = 'The email address is already in use by another account.',
  });
}

class WeakPasswordException extends ServerException {
  const WeakPasswordException({
    super.message = 'The password provided is too weak.',
  });
}

class TaskNotFoundException implements Exception {}
