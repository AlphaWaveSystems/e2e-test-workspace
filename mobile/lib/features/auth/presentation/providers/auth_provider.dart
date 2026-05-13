import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/error/failures.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loginUseCase = GetIt.instance<LoginUseCase>();
      _currentUser = await loginUseCase(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthFailure catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Marks the user as authenticated after a successful biometric capture.
  /// Used by [BiometricLoginPage]; bypasses email/password since the OS
  /// has already proven identity.
  Future<void> loginWithBiometrics() async {
    _currentUser = const User(
      id: -1,
      email: 'biometric@local',
      name: 'Biometric User',
    );
    _error = null;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
