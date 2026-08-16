package com.alphawavesystems.probe_test_app_native.screens

import android.content.Intent
import androidx.core.net.toUri
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Send
import androidx.compose.material.icons.filled.Share
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlinx.coroutines.launch

/// Twin of the Flutter app's DevicePage. Camera/location "permissions" are
/// simulated state transitions exactly like the Flutter twin (which never
/// calls the real permission APIs either) so probe assertions stay
/// deterministic; the browser button fires a real ACTION_VIEW intent and the
/// clipboard section reads the real system clipboard.
@Composable
fun DeviceScreen(navController: NavController) {
    var cameraStatus by remember { mutableStateOf("Not requested") }
    var locationStatus by remember { mutableStateOf("Not requested") }
    var gpsDisplay by remember { mutableStateOf("Location: --") }
    var copyText by remember { mutableStateOf("Copy this text") }
    var pastedText by remember { mutableStateOf("") }

    val context = LocalContext.current
    val clipboard = LocalClipboardManager.current
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    ScreenScaffold("Device", navController, snackbarHostState) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            Text("Permissions", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = { cameraStatus = "Granted" },
                modifier = Modifier.testTag("request_camera"),
            ) {
                Icon(Icons.Filled.Person, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text("Request Camera")
            }
            Spacer(Modifier.height(4.dp))
            Text("Camera: $cameraStatus", modifier = Modifier.testTag("camera_status"))
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = {
                    locationStatus = "Granted"
                    gpsDisplay = "Location: 37.7749, -122.4194"
                },
                modifier = Modifier.testTag("request_location"),
            ) {
                Icon(Icons.Filled.LocationOn, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text("Request Location")
            }
            Spacer(Modifier.height(4.dp))
            Text("Location: $locationStatus", modifier = Modifier.testTag("location_status"))
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = {
                    scope.launch {
                        snackbarHostState.showSnackbar("Notification permission requested")
                    }
                },
                modifier = Modifier.testTag("request_notifications"),
            ) {
                Icon(Icons.Filled.Notifications, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text("Request Notifications")
            }
            Spacer(Modifier.height(24.dp))

            Text("GPS", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(8.dp))
            Text(gpsDisplay, modifier = Modifier.testTag("gps_display"), fontSize = 16.sp)
            Spacer(Modifier.height(24.dp))

            Text("Browser", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = {
                    context.startActivity(
                        Intent(Intent.ACTION_VIEW, "https://www.google.com".toUri()),
                    )
                },
                modifier = Modifier.testTag("open_browser"),
            ) {
                Icon(Icons.Filled.Share, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text("Open Website")
            }
            Spacer(Modifier.height(24.dp))

            Text("Clipboard", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(8.dp))
            OutlinedTextField(
                value = copyText,
                onValueChange = { copyText = it },
                modifier = Modifier.fillMaxWidth().testTag("copy_text_field"),
                label = { Text("Text to copy") },
                singleLine = true,
            )
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = {
                    pastedText = clipboard.getText()?.text ?: "Nothing in clipboard"
                },
                modifier = Modifier.testTag("paste_button"),
            ) {
                Icon(Icons.Filled.Send, contentDescription = null)
                Spacer(Modifier.width(8.dp))
                Text("Paste")
            }
            Spacer(Modifier.height(8.dp))
            Text(pastedText, modifier = Modifier.testTag("pasted_text"), fontSize = 14.sp)
        }
    }
}
