part of 'user_details_page.dart';

class UserDetailsPageProvider extends ChangeNotifier {
  bool _isSubmitButtonEnabled = false;

  DateTime? _birthDate;

  Gender? _gender;

  void setSubmitButtonEnabledState(bool isLoading) {
    _isSubmitButtonEnabled = isLoading;
    notifyListeners();
  }

  bool get isSubmitButtonEnabled => _isSubmitButtonEnabled;

  void setBirthDate(DateTime date) {
    _birthDate = date;
    notifyListeners();
  }

  DateTime? get birthDate => _birthDate;

  void setGender(Gender gender) {
    _gender = gender;
    notifyListeners();
  }

  Gender? get gender => _gender;
}
