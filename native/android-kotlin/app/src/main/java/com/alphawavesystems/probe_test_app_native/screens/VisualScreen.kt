package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController

/// Twin of the Flutter app's VisualPage: static header, 2x2 color grid,
/// tap counter, image placeholder, and a typography sample.
@Composable
fun VisualScreen(navController: NavController) {
    var counter by remember { mutableIntStateOf(0) }

    ScreenScaffold("Visual", navController) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Color(0xFF673AB7), RoundedCornerShape(12.dp))
                    .padding(24.dp)
                    .testTag("visual_header"),
                contentAlignment = Alignment.Center,
            ) {
                Text(
                    "Visual Test",
                    color = Color.White,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                )
            }
            Spacer(Modifier.height(24.dp))

            Column(
                modifier = Modifier.fillMaxWidth().testTag("color_grid"),
                verticalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    ColorCell("Red", Color(0xFFF44336), Color.White, Modifier.weight(1f))
                    ColorCell("Green", Color(0xFF4CAF50), Color.White, Modifier.weight(1f))
                }
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    ColorCell("Blue", Color(0xFF2196F3), Color.White, Modifier.weight(1f))
                    ColorCell("Yellow", Color(0xFFFFEB3B), Color.Black, Modifier.weight(1f))
                }
            }
            Spacer(Modifier.height(24.dp))

            Text(
                "Count: $counter",
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .testTag("visual_counter"),
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
            )
            Spacer(Modifier.height(12.dp))
            Button(
                onClick = { counter++ },
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .testTag("increment_button"),
            ) {
                Text("Increment")
            }
            Spacer(Modifier.height(24.dp))

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(150.dp)
                    .background(Color(0xFFE0E0E0), RoundedCornerShape(8.dp))
                    .border(1.dp, Color.Gray, RoundedCornerShape(8.dp))
                    .testTag("static_image"),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Icon(
                    Icons.Filled.Star,
                    contentDescription = null,
                    tint = Color.Gray,
                    modifier = Modifier.height(48.dp),
                )
                Spacer(Modifier.height(8.dp))
                Text("Image Placeholder", color = Color.Gray)
            }
            Spacer(Modifier.height(24.dp))

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .border(1.dp, Color(0xFFE0E0E0), RoundedCornerShape(8.dp))
                    .padding(16.dp)
                    .testTag("typography_sample"),
            ) {
                Text("Heading 1", fontSize = 32.sp, fontWeight = FontWeight.Bold)
                Spacer(Modifier.height(8.dp))
                Text("Heading 2", fontSize = 24.sp, fontWeight = FontWeight.SemiBold)
                Spacer(Modifier.height(8.dp))
                Text("Body text at 16px", fontSize = 16.sp)
                Spacer(Modifier.height(8.dp))
                Text("Caption text at 12px", fontSize = 12.sp)
                Spacer(Modifier.height(8.dp))
                Text("Small text at 10px", fontSize = 10.sp)
            }
        }
    }
}

@Composable
private fun ColorCell(
    label: String,
    background: Color,
    textColor: Color,
    modifier: Modifier = Modifier,
) {
    Box(
        modifier = modifier
            .aspectRatio(1.6f)
            .background(background, RoundedCornerShape(8.dp)),
        contentAlignment = Alignment.Center,
    ) {
        Text(label, color = textColor, fontSize = 18.sp)
    }
}
