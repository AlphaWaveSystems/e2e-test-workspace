package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.navigation.NavController

/// Shared scaffold used by every sub-screen: top bar with the screen title
/// (the text every probe test asserts on) and a back arrow, mirroring the
/// Flutter app's AppBar behavior.
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ScreenScaffold(
    title: String,
    navController: NavController,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
    actions: @Composable () -> Unit = {},
    floatingActionButton: @Composable () -> Unit = {},
    showBack: Boolean = true,
    content: @Composable (PaddingValues) -> Unit,
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(title) },
                navigationIcon = {
                    if (showBack) {
                        // Tagged because the native verb family has no generic
                        // `go back`; suites navigate home via this button.
                        IconButton(
                            onClick = { navController.popBackStack() },
                            modifier = Modifier.testTag("back_button"),
                        ) {
                            Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                        }
                    }
                },
                actions = { actions() },
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) },
        floatingActionButton = floatingActionButton,
    ) { padding ->
        content(padding)
    }
}
