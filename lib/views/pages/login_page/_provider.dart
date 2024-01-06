part of 'login_page.dart';

class LoginPageProvider extends ChangeNotifier {
  bool _isRegisterButtonLoading = false;

  void setRegisterButtonLoadingState(bool isLoading) {
    _isRegisterButtonLoading = isLoading;
    notifyListeners();
  }

  bool get isRegisterButtonLoading => _isRegisterButtonLoading;
}
