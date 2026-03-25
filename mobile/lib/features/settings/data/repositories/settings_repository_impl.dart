import '../../domain/entities/preferences.dart';

class SettingsRepositoryImpl {
  AppPreferences _preferences = const AppPreferences();

  AppPreferences get preferences => _preferences;

  void savePreferences(AppPreferences preferences) {
    _preferences = preferences;
  }

  void updateDarkMode(bool value) {
    _preferences = _preferences.copyWith(darkMode: value);
  }

  void updateNotifications(bool value) {
    _preferences = _preferences.copyWith(notifications: value);
  }

  void updateTermsAccepted(bool value) {
    _preferences = _preferences.copyWith(termsAccepted: value);
  }

  void updateLanguage(String value) {
    _preferences = _preferences.copyWith(language: value);
  }
}
