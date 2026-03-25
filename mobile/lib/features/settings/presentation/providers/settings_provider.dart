import 'package:flutter/foundation.dart';

import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepositoryImpl _repository = SettingsRepositoryImpl();

  AppPreferences get preferences => _repository.preferences;

  bool get darkMode => _repository.preferences.darkMode;
  bool get notifications => _repository.preferences.notifications;
  bool get termsAccepted => _repository.preferences.termsAccepted;
  String get language => _repository.preferences.language;

  void toggleDarkMode(bool value) {
    _repository.updateDarkMode(value);
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _repository.updateNotifications(value);
    notifyListeners();
  }

  void toggleTermsAccepted(bool value) {
    _repository.updateTermsAccepted(value);
    notifyListeners();
  }

  void setLanguage(String value) {
    _repository.updateLanguage(value);
    notifyListeners();
  }

  void savePreferences() {
    _repository.savePreferences(_repository.preferences);
    notifyListeners();
  }
}
