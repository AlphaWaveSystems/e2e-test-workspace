package com.alphawavesystems.probe_test_app_native.data

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

/// Twin of the Flutter app's AuthProvider (ChangeNotifier).
class AuthViewModel : ViewModel() {
    var currentUser by mutableStateOf<User?>(null)
        private set
    var isLoading by mutableStateOf(false)
        private set
    var error by mutableStateOf<String?>(null)
        private set

    val isAuthenticated: Boolean get() = currentUser != null

    fun login(email: String, password: String, onSuccess: () -> Unit) {
        isLoading = true
        error = null
        viewModelScope.launch {
            try {
                currentUser = AuthRepository.login(email.trim(), password)
                isLoading = false
                onSuccess()
            } catch (e: AuthFailure) {
                error = e.message
                isLoading = false
            } catch (e: Exception) {
                error = "An unexpected error occurred"
                isLoading = false
            }
        }
    }

    /// Marks the user as authenticated after a successful biometric capture.
    /// Bypasses email/password since the OS has already proven identity.
    fun loginWithBiometrics() {
        currentUser = User(id = -1, email = "biometric@local", name = "Biometric User")
        error = null
    }

    fun logout() {
        currentUser = null
        error = null
    }
}
