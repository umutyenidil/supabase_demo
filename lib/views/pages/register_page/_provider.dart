part of 'register_page.dart';

class RegisterPageProvider extends ChangeNotifier {
  bool _isRegisterButtonLoading = false;

  void setRegisterButtonLoadingState(bool isLoading) {
    _isRegisterButtonLoading = isLoading;
    notifyListeners();
  }

  bool get isRegisterButtonLoading => _isRegisterButtonLoading;
}
