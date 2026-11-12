package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ExitToApp
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.alphawavesystems.probe_test_app_native.data.AuthViewModel
import com.alphawavesystems.probe_test_app_native.navigation.Routes
import kotlinx.coroutines.launch

/// Twin of the Flutter app's DashboardPage.
@Composable
fun DashboardScreen(navController: NavController, auth: AuthViewModel) {
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val userName = auth.currentUser?.name ?: "Guest"

    ScreenScaffold(
        title = "Dashboard",
        navController = navController,
        snackbarHostState = snackbarHostState,
        actions = {
            IconButton(
                onClick = {
                    scope.launch { snackbarHostState.showSnackbar("Refreshed") }
                },
                modifier = Modifier.testTag("refresh_button"),
            ) {
                Icon(Icons.Filled.Refresh, contentDescription = "Refresh")
            }
            IconButton(
                onClick = {
                    auth.logout()
                    navController.navigate(Routes.HOME) {
                        popUpTo(Routes.HOME) { inclusive = true }
                    }
                },
                modifier = Modifier.testTag("logout_button"),
            ) {
                Icon(Icons.AutoMirrored.Filled.ExitToApp, contentDescription = "Logout")
            }
        },
    ) { padding ->
        LazyColumn(
            modifier = Modifier.padding(padding).fillMaxSize(),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(16.dp),
        ) {
            item {
                Card(
                    modifier = Modifier.fillMaxWidth().testTag("welcome_banner"),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.primaryContainer,
                    ),
                ) {
                    Column(Modifier.padding(20.dp)) {
                        Text(
                            "Welcome, $userName",
                            style = MaterialTheme.typography.headlineSmall,
                            color = MaterialTheme.colorScheme.onPrimaryContainer,
                        )
                        Spacer(Modifier.height(4.dp))
                        Text(
                            "Here is your dashboard overview",
                            color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f),
                        )
                    }
                }
                Spacer(Modifier.height(16.dp))
                Row {
                    StatCard("stat_card_1", "Tests Run", "42", Icons.Filled.CheckCircle, Modifier.weight(1f))
                    Spacer(Modifier.width(8.dp))
                    StatCard("stat_card_2", "Passed", "38", Icons.Filled.ThumbUp, Modifier.weight(1f))
                    Spacer(Modifier.width(8.dp))
                    StatCard("stat_card_3", "Failed", "4", Icons.Filled.Warning, Modifier.weight(1f))
                }
                Spacer(Modifier.height(24.dp))
                Text("Recent Items", style = MaterialTheme.typography.titleMedium)
                Spacer(Modifier.height(8.dp))
            }
            items(10) { index ->
                ListItem(
                    modifier = Modifier
                        .testTag("item_$index")
                        .clickable {
                            scope.launch {
                                snackbarHostState.showSnackbar("Tapped item ${index + 1}")
                            }
                        },
                    leadingContent = { Text("${index + 1}") },
                    headlineContent = { Text("Item ${index + 1}") },
                    supportingContent = { Text("Description for item ${index + 1}") },
                    trailingContent = {
                        Icon(Icons.AutoMirrored.Filled.KeyboardArrowRight, contentDescription = null)
                    },
                )
            }
        }
    }
}

@Composable
private fun StatCard(
    tag: String,
    title: String,
    value: String,
    icon: ImageVector,
    modifier: Modifier = Modifier,
) {
    Card(modifier = modifier.testTag(tag)) {
        Column(
            Modifier.fillMaxWidth().padding(12.dp),
            horizontalAlignment = androidx.compose.ui.Alignment.CenterHorizontally,
        ) {
            Icon(icon, contentDescription = null, tint = MaterialTheme.colorScheme.primary)
            Spacer(Modifier.height(8.dp))
            Text(
                value,
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
            )
            Text(
                title,
                style = MaterialTheme.typography.bodySmall,
                textAlign = TextAlign.Center,
            )
        }
    }
}
