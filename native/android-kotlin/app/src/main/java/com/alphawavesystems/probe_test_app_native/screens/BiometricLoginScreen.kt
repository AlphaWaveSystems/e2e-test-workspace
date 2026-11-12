package com.alphawavesystems.probe_test_app_native.screens

import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.compose.foundation.border
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Face
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import androidx.navigation.NavController
import com.alphawavesystems.probe_test_app_native.data.AuthViewModel
import com.alphawavesystems.probe_test_app_native.navigation.Routes

/// Twin of the Flutter app's BiometricLoginPage, backed by the real Android
/// BiometricPrompt (fingerprint on the emulator).
///
/// Driven by flutter-probe's biometric verbs:
///   - `enroll biometric`   — no-op on Android (enroll a fingerprint once in
///                            emulator Settings; `adb emu finger touch` needs it)
///   - `biometric match`    — `adb emu finger touch 1` -> onAuthenticationSucceeded
///   - `biometric no match` — `adb emu finger touch 9999` -> onAuthenticationFailed
///
/// Like the Flutter twin, the flow is single-shot: the first no-match cancels
/// the prompt and shows the "Authentication failed" banner instead of letting
/// the OS dialog retry forever — keeping no-match deterministic to assert.
@Composable
fun BiometricLoginScreen(navController: NavController, auth: AuthViewModel) {
    val context = LocalContext.current
    var busy by remember { mutableStateOf(false) }
    var error by remember { mutableStateOf<String?>(null) }

    fun onSuccess() {
        auth.loginWithBiometrics()
        navController.navigate(Routes.DASHBOARD) {
            popUpTo(Routes.HOME)
        }
    }

    fun startBiometricAuth() {
        busy = true
        error = null

        val activity = context as? FragmentActivity
        val canAuth = BiometricManager.from(context).canAuthenticate(
            BiometricManager.Authenticators.BIOMETRIC_WEAK,
        )
        if (activity == null || canAuth != BiometricManager.BIOMETRIC_SUCCESS) {
            // Mirrors the Flutter twin: any platform-level problem (no
            // hardware, nothing enrolled) is treated as an auth failure.
            busy = false
            error = "Authentication failed"
            return
        }

        lateinit var prompt: BiometricPrompt
        val callback = object : BiometricPrompt.AuthenticationCallback() {
            override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                busy = false
                onSuccess()
            }

            override fun onAuthenticationFailed() {
                // Single-shot: first no-match cancels the OS dialog.
                prompt.cancelAuthentication()
                busy = false
                error = "Authentication failed"
            }

            override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                busy = false
                if (error == null) error = "Authentication failed"
            }
        }

        prompt = BiometricPrompt(activity, ContextCompat.getMainExecutor(context), callback)
        prompt.authenticate(
            BiometricPrompt.PromptInfo.Builder()
                .setTitle("Biometric Login")
                .setSubtitle("Sign in to your account")
                .setNegativeButtonText("Cancel")
                .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_WEAK)
                .build(),
        )
    }

    ScreenScaffold("Biometric Login", navController) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .padding(24.dp),
        ) {
            Spacer(Modifier.height(48.dp))
            Icon(
                Icons.Filled.Face,
                contentDescription = null,
                modifier = Modifier.size(96.dp).align(Alignment.CenterHorizontally),
            )
            Spacer(Modifier.height(16.dp))
            Text(
                "Use your face or fingerprint to sign in.",
                modifier = Modifier.fillMaxWidth().testTag("biometric_prompt_intro"),
                textAlign = TextAlign.Center,
            )
            Spacer(Modifier.height(32.dp))
            Button(
                onClick = { startBiometricAuth() },
                enabled = !busy,
                modifier = Modifier.fillMaxWidth().testTag("sign_in_with_face_id"),
            ) {
                Icon(Icons.Filled.Face, contentDescription = null)
                Spacer(Modifier.size(8.dp))
                Text("Sign in with Face ID")
            }
            if (busy) {
                Spacer(Modifier.height(24.dp))
                CircularProgressIndicator(
                    modifier = Modifier
                        .align(Alignment.CenterHorizontally)
                        .padding(8.dp)
                        .testTag("biometric_progress"),
                )
            }
            error?.let { message ->
                Spacer(Modifier.height(24.dp))
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color(0xFFFFEBEE), RoundedCornerShape(8.dp))
                        .border(1.dp, Color(0xFFEF9A9A), RoundedCornerShape(8.dp))
                        .padding(12.dp)
                        .testTag("biometric_error_banner"),
                ) {
                    Text(message, color = Color(0xFFC62828))
                }
            }
        }
    }
}
