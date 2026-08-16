package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/// Twin of the Flutter app's API demo page (route /api): simulated fetch and
/// post with the same latencies and result texts.
@Composable
fun ApiScreen(navController: NavController) {
    var loading by remember { mutableStateOf(false) }
    var error by remember { mutableStateOf<String?>(null) }
    var users by remember { mutableStateOf<List<String>>(emptyList()) }
    var postResult by remember { mutableStateOf<String?>(null) }
    val scope = rememberCoroutineScope()

    ScreenScaffold("API Demo", navController) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            Button(
                onClick = {
                    scope.launch {
                        loading = true
                        error = null
                        delay(1000)
                        users = listOf("Leanne Graham", "Ervin Howell", "Clementine Bauch")
                        loading = false
                    }
                },
                enabled = !loading,
                modifier = Modifier.fillMaxWidth().testTag("fetch_users_button"),
            ) {
                Text("Fetch Users")
            }
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = {
                    scope.launch {
                        loading = true
                        error = null
                        delay(500)
                        postResult = "Post created with id: 101"
                        loading = false
                    }
                },
                enabled = !loading,
                modifier = Modifier.fillMaxWidth().testTag("create_post_button"),
            ) {
                Text("Create Post")
            }
            Spacer(Modifier.height(16.dp))
            if (loading) {
                CircularProgressIndicator(
                    modifier = Modifier
                        .align(Alignment.CenterHorizontally)
                        .testTag("api_loading"),
                )
            }
            error?.let {
                Text(
                    it,
                    modifier = Modifier.testTag("api_error"),
                    color = MaterialTheme.colorScheme.error,
                    fontSize = 16.sp,
                )
            }
            if (users.isNotEmpty()) {
                Text("Users:", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                users.forEachIndexed { i, user ->
                    Text(
                        user,
                        modifier = Modifier
                            .padding(vertical = 4.dp)
                            .testTag("user_$i"),
                    )
                }
            }
            postResult?.let {
                Text(
                    it,
                    modifier = Modifier
                        .padding(top = 16.dp)
                        .testTag("post_result"),
                    fontSize = 16.sp,
                    color = Color(0xFF4CAF50),
                )
            }
        }
    }
}
