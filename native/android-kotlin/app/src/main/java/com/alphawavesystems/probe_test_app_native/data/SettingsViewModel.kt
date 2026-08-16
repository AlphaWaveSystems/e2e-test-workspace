package com.alphawavesystems.probe_test_app_native.data

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel

/// Twin of the Flutter app's SettingsProvider + AppPreferences entity.
/// Same defaults: darkMode=false, notifications=true, terms=false, English.
class SettingsViewModel : ViewModel() {
    var darkMode by mutableStateOf(false)
        private set
    var notifications by mutableStateOf(true)
        private set
    var termsAccepted by mutableStateOf(false)
        private set
    var language by mutableStateOf("English")
        private set

    val languages = listOf("English", "Spanish", "French", "German", "Japanese")

    fun toggleDarkMode(value: Boolean) { darkMode = value }
    fun toggleNotifications(value: Boolean) { notifications = value }
    fun toggleTermsAccepted(value: Boolean) { termsAccepted = value }
    fun selectLanguage(value: String) { language = value }

    /// In-memory persistence, matching the Flutter twin's
    /// SettingsRepositoryImpl (which also keeps preferences in memory).
    fun savePreferences() { /* no-op: state is already the source of truth */ }
}
