package com.alphawavesystems.probe_test_app_native

import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.testTagsAsResourceId
import androidx.fragment.app.FragmentActivity
import com.alphawavesystems.probe_test_app_native.navigation.AppNavHost

/// Native Android (Jetpack Compose) twin of the Flutter probe test app.
///
/// Extends [FragmentActivity] (not plain ComponentActivity) because
/// androidx.biometric's BiometricPrompt requires a FragmentActivity host.
class MainActivity : FragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ProbeTestAppNative()
        }
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun ProbeTestAppNative() {
    // Mirror the Flutter app's deep-purple Material 3 light theme.
    MaterialTheme(
        colorScheme = lightColorScheme(primary = Color(0xFF6750A4)),
    ) {
        Surface(
            modifier = Modifier
                .fillMaxSize()
                // Surfaces every Modifier.testTag(...) in the tree as a
                // uiautomator resource-id so flutter-probe's native verbs
                // (`tap native`, `see native`, `type native`) can match by id.
                .semantics { testTagsAsResourceId = true },
        ) {
            AppNavHost()
        }
    }
}
