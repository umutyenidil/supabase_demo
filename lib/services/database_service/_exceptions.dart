part of 'database_service.dart';

class DatabaseServiceException implements Exception {
  final String? _message;

  DatabaseServiceException(String? message) : _message = message;

  String? get message => _message;
}

class InvalidLoginCredentialsException extends DatabaseServiceException {
  InvalidLoginCredentialsException() : super('Wrong email or password');
}

class InvalidEmailAddressException extends DatabaseServiceException {
  InvalidEmailAddressException() : super('Invalid email address');
}

class InvalidPasswordException extends DatabaseServiceException {
  InvalidPasswordException() : super('Invalid password');
}

class NeedLoginException extends DatabaseServiceException {
  NeedLoginException() : super('Need login');
}

class UserAlreadyRegisteredException extends DatabaseServiceException {
  UserAlreadyRegisteredException() : super('User already registered');
}
