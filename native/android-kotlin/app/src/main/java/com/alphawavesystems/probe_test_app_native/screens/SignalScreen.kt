package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/// Twin of the Flutter app's SignalDemoPage.
///
/// Deliberate deviation: the Flutter twin's PROBE_AGENT builds block on
/// `awaitSignal(...)` so the CLI's `deliver signal` verb can resolve them.
/// That mechanism lives in the Dart ProbeAgent and has no native-side
/// counterpart, so this twin always uses the "real implementation" path the
/// Flutter app uses outside probe mode: a 1 second async operation that then
/// lands on the same status texts (`Notifications enabled`, `Payment
/// confirmed`, `Opened: https://example.com`).
@Composable
fun SignalScreen(navController: NavController) {
    var status by remember { mutableStateOf("") }
    var busy by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()

    fun run(pendingStatus: String, finalStatus: String) {
        scope.launch {
            busy = true
            status = pendingStatus
            delay(1000)
            busy = false
            status = finalStatus
        }
    }

    ScreenScaffold("Signal Demo", navController) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .padding(24.dp),
        ) {
            Spacer(Modifier.height(24.dp))
            Button(
                onClick = { run("Waiting for permission…", "Notifications enabled") },
                enabled = !busy,
                modifier = Modifier.fillMaxWidth().testTag("request_push_permission"),
            ) {
                Text("Request Push Permission")
            }
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = { run("Payment in progress…", "Payment confirmed") },
                enabled = !busy,
                modifier = Modifier.fillMaxWidth().testTag("start_payment"),
            ) {
                Text("Start Payment")
            }
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = { run("Opening link…", "Opened: https://example.com") },
                enabled = !busy,
                modifier = Modifier.fillMaxWidth().testTag("open_deep_link"),
            ) {
                Text("Open Deep Link")
            }
            if (busy) {
                Spacer(Modifier.height(24.dp))
                CircularProgressIndicator(
                    modifier = Modifier
                        .align(Alignment.CenterHorizontally)
                        .testTag("signal_progress"),
                )
            }
            if (status.isNotEmpty()) {
                Spacer(Modifier.height(24.dp))
                Text(
                    status,
                    modifier = Modifier.fillMaxWidth().testTag("signal_status"),
                    textAlign = TextAlign.Center,
                    style = MaterialTheme.typography.titleMedium,
                )
            }
        }
    }
}
