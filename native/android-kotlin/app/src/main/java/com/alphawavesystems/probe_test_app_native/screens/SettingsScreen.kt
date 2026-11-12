package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MenuAnchorType
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.alphawavesystems.probe_test_app_native.data.SettingsViewModel
import kotlinx.coroutines.launch

/// Twin of the Flutter app's SettingsPage.
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(navController: NavController, settings: SettingsViewModel) {
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    var languageMenuExpanded by remember { mutableStateOf(false) }

    ScreenScaffold("Settings", navController, snackbarHostState) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            Row(
                modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text("Dark Mode", Modifier.weight(1f))
                Switch(
                    checked = settings.darkMode,
                    onCheckedChange = settings::toggleDarkMode,
                    modifier = Modifier.testTag("dark_mode_toggle"),
                )
            }
            Row(
                modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text("Notifications", Modifier.weight(1f))
                Switch(
                    checked = settings.notifications,
                    onCheckedChange = settings::toggleNotifications,
                    modifier = Modifier.testTag("notifications_toggle"),
                )
            }
            Row(
                modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text("Agree to Terms", Modifier.weight(1f))
                Checkbox(
                    checked = settings.termsAccepted,
                    onCheckedChange = settings::toggleTermsAccepted,
                    modifier = Modifier.testTag("terms_checkbox"),
                )
            }
            Spacer(Modifier.height(16.dp))
            ExposedDropdownMenuBox(
                expanded = languageMenuExpanded,
                onExpandedChange = { languageMenuExpanded = it },
            ) {
                OutlinedTextField(
                    value = settings.language,
                    onValueChange = {},
                    readOnly = true,
                    label = { Text("Language") },
                    trailingIcon = {
                        ExposedDropdownMenuDefaults.TrailingIcon(expanded = languageMenuExpanded)
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .menuAnchor(MenuAnchorType.PrimaryNotEditable)
                        .testTag("language_dropdown"),
                )
                ExposedDropdownMenu(
                    expanded = languageMenuExpanded,
                    onDismissRequest = { languageMenuExpanded = false },
                ) {
                    settings.languages.forEach { lang ->
                        DropdownMenuItem(
                            text = { Text(lang) },
                            onClick = {
                                settings.selectLanguage(lang)
                                languageMenuExpanded = false
                            },
                        )
                    }
                }
            }
            Spacer(Modifier.height(24.dp))
            Button(
                onClick = {
                    settings.savePreferences()
                    scope.launch { snackbarHostState.showSnackbar("Settings saved") }
                },
                modifier = Modifier.fillMaxWidth().testTag("save_button"),
            ) {
                Text("Save")
            }
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = {},
                enabled = false,
                colors = ButtonDefaults.buttonColors(disabledContainerColor = Color.Gray),
                modifier = Modifier.fillMaxWidth().testTag("delete_button"),
            ) {
                Text("Delete Account")
            }
            Spacer(Modifier.height(24.dp))
            Text(
                "Build: 1.0.42+dev",
                modifier = Modifier.fillMaxWidth().testTag("build_info"),
                style = MaterialTheme.typography.bodySmall,
                color = Color.Gray,
                textAlign = TextAlign.Center,
            )
        }
    }
}
