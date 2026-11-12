package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlin.random.Random
import kotlinx.coroutines.delay

/// Twin of the Flutter app's DynamicPage: random A/B banner, 10s countdown,
/// 2s fade-in widget, error dialog, and a repeatable tap counter.
@Composable
fun DynamicScreen(navController: NavController) {
    val showAbBanner = remember { Random.nextBoolean() }
    var countdown by remember { mutableIntStateOf(10) }
    var actionCount by remember { mutableIntStateOf(0) }
    var showErrorDialog by remember { mutableStateOf(false) }
    val fadeAlpha = remember { Animatable(0f) }

    LaunchedEffect(Unit) {
        fadeAlpha.animateTo(1f, animationSpec = tween(durationMillis = 2000))
    }
    LaunchedEffect(Unit) {
        while (countdown > 0) {
            delay(1000)
            countdown--
        }
    }

    if (showErrorDialog) {
        AlertDialog(
            modifier = Modifier.testTag("error_dialog"),
            onDismissRequest = { showErrorDialog = false },
            title = { Text("Error") },
            text = { Text("Something went wrong!") },
            confirmButton = {
                TextButton(onClick = { showErrorDialog = false }) {
                    Text("OK")
                }
            },
        )
    }

    ScreenScaffold("Dynamic", navController) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            if (showAbBanner) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 16.dp)
                        .background(Color(0xFFFFC107), RoundedCornerShape(8.dp))
                        .padding(16.dp)
                        .testTag("ab_banner"),
                    contentAlignment = Alignment.Center,
                ) {
                    Text(
                        "Special Offer!",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        textAlign = TextAlign.Center,
                    )
                }
            }

            Text("Countdown", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(8.dp))
            Text(
                "$countdown",
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .testTag("countdown"),
                fontSize = 48.sp,
                fontWeight = FontWeight.Bold,
                color = if (countdown <= 3) Color.Red else Color.Black,
            )
            Spacer(Modifier.height(24.dp))

            Text("Fade Animation", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(8.dp))
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(80.dp)
                    .graphicsLayer { alpha = fadeAlpha.value }
                    .background(Color(0xFF009688), RoundedCornerShape(8.dp))
                    .testTag("fade_widget"),
                contentAlignment = Alignment.Center,
            ) {
                Text("I faded in!", color = Color.White, fontSize = 18.sp)
            }
            Spacer(Modifier.height(24.dp))

            Text("Error Handling", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = { showErrorDialog = true },
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFFF44336),
                    contentColor = Color.White,
                ),
                modifier = Modifier.testTag("trigger_error"),
            ) {
                Text("Trigger Error")
            }
            Spacer(Modifier.height(24.dp))

            Text("Repeatable Action", fontWeight = FontWeight.Bold, fontSize = 18.sp)
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = { actionCount++ },
                modifier = Modifier.testTag("repeat_action"),
            ) {
                Text("Tap Me")
            }
            Spacer(Modifier.height(8.dp))
            Text(
                "Tapped: $actionCount",
                modifier = Modifier.testTag("action_count"),
                fontSize = 16.sp,
            )
        }
    }
}
