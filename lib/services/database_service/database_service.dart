import 'package:supabase_flutter/supabase_flutter.dart';

part '_exceptions.dart';

part '_enums.dart';

part '_helpers.dart';

class DatabaseService {
  late final SupabaseClient _client;

  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  /// Initializes the database service
  ///
  /// **It should be called in the main method**
  Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://vmaxmaavaxumzshneoly.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZtYXhtYWF2YXh1bXpzaG5lb2x5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ0NTQxOTksImV4cCI6MjAyMDAzMDE5OX0.N3UeKz9MW63w-CvAyQqAGg0LIaBZQbC6OgG-Z81xoa0',
    );

    _client = Supabase.instance.client;
  }

  /// User login with email address and password
  ///
  /// throws [InvalidLoginCredentialsException] if email address or password is not matched with any account
  /// throws [InvalidEmailAddressException] if email address is not valid form
  Future<void> login({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await _client.auth.signUp(
        password: password.trim(),
        email: emailAddress.trim(),
      );
    } on AuthException catch (authException) {
      int statusCode = int.parse(authException.statusCode!);
      switch (statusCode) {
        case 400:
          throw InvalidLoginCredentialsException();
        case 409:
          throw UserAlreadyRegisteredException();
        case 422:
          throw InvalidEmailAddressException();
      }
    } catch (exception) {
      print(exception);
    }
  }

  /// User register with email address and password
  ///
  /// throws [InvalidEmailAddressException] if email address is not valid form
  Future<void> register({
    required String emailAddress,
    required String password,
  }) async {
    try {
      await _client.auth.signUp(
        password: password.trim(),
        email: emailAddress.trim(),
      );
    } on AuthException catch (authException) {
      _handleAuthExceptions(authException);
    } catch (exception) {
      print(exception);
    }
  }

  /// Update user details
  ///
  /// throws [NeedLoginException] if user not logged in
  Future<void> updateUserDetails({
    String? fcmToken,
    String? firstName,
    String? lastName,
    Gender? gender,
    DateTime? birthDate,
  }) async {
    Map<String, dynamic> data = {};

    if (fcmToken != null && fcmToken.isNotEmpty) data.addAll({'fcm_token': fcmToken});

    if (firstName != null && firstName.isNotEmpty) data.addAll({'first_name': firstName});

    if (lastName != null && lastName.isNotEmpty) data.addAll({'last_name': lastName});

    if (gender != null) data.addAll({'gender': gender.name});

    if (birthDate != null) data.addAll({'birth_date': birthDate.toIso8601String()});

    print(data);

    if (data.isNotEmpty) {
      if (_client.auth.currentUser == null) {
        throw NeedLoginException();
      }

      await _client.from('user_details').update(data).eq('user_id', _client.auth.currentUser!.id);
    }
  }
}
