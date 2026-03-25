class AppPreferences {
  final bool darkMode;
  final bool notifications;
  final bool termsAccepted;
  final String language;

  const AppPreferences({
    this.darkMode = false,
    this.notifications = true,
    this.termsAccepted = false,
    this.language = 'English',
  });

  AppPreferences copyWith({
    bool? darkMode,
    bool? notifications,
    bool? termsAccepted,
    String? language,
  }) {
    return AppPreferences(
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      language: language ?? this.language,
    );
  }
}
