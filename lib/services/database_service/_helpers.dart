part of 'database_service.dart';

void _handleAuthExceptions(AuthException authException) {
  int statusCode = int.parse(authException.statusCode!);
  String message = authException.message;
  print(authException.message);
  print(statusCode);

  switch (statusCode) {
    case 400:
      throw UserAlreadyRegisteredException();
    case 422:
      if (message == 'Password should be at least 6 characters.') {
        throw InvalidPasswordException();
      }
      throw InvalidEmailAddressException();
    default:
  }
}
