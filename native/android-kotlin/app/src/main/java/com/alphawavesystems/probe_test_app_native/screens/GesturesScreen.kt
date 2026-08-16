package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Share
import androidx.compose.material3.Card
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.Text
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.boundsInRoot
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlin.math.roundToInt

/// Twin of the Flutter app's GesturesPage: drag & drop, double tap,
/// long press (context menu), and a dismissible swipe card, all feeding a
/// shared gesture counter.
///
/// Native-twin addition (not in the Flutter page): a single-"Tap" zone
/// (`tap_capture_area` / `tap_capture_count`). flutter-probe's native verb
/// family has no double-tap/long-press/swipe equivalents yet, so this gives
/// `tap native` a real gesture target whose recognized-gesture state can be
/// asserted. (Named `tap_capture_*` rather than `tap_*` because native
/// matching is substring-based and `tap_area` would collide with
/// `double_tap_area`.)
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun GesturesScreen(navController: NavController) {
    var gestureCount by remember { mutableIntStateOf(0) }
    var tapCount by remember { mutableIntStateOf(0) }
    var doubleTapCount by remember { mutableIntStateOf(0) }
    var dragAccepted by remember { mutableStateOf(false) }
    var swipeCardVisible by remember { mutableStateOf(true) }
    var longPressMenuVisible by remember { mutableStateOf(false) }

    // Drag & drop bookkeeping.
    var dragOffset by remember { mutableStateOf(Offset.Zero) }
    var sourceBounds by remember { mutableStateOf(Rect.Zero) }
    var targetBounds by remember { mutableStateOf(Rect.Zero) }

    ScreenScaffold("Gestures", navController) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
        ) {
            Text(
                "Gesture Count: $gestureCount",
                modifier = Modifier.testTag("gesture_count"),
                style = MaterialTheme.typography.titleMedium,
            )
            Spacer(Modifier.height(24.dp))

            SectionLabel("Tap")
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(60.dp)
                    .background(Color(0xFFB3E5FC))
                    .testTag("tap_capture_area")
                    .pointerInput(Unit) {
                        detectTapGestures(onTap = {
                            tapCount++
                            gestureCount++
                        })
                    },
                contentAlignment = Alignment.Center,
            ) {
                Text("Taps: $tapCount", fontSize = 16.sp, modifier = Modifier.testTag("tap_capture_count"))
            }
            Spacer(Modifier.height(24.dp))

            SectionLabel("Drag & Drop")
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = androidx.compose.foundation.layout.Arrangement.SpaceEvenly,
            ) {
                Box(
                    modifier = Modifier
                        .offset { IntOffset(dragOffset.x.roundToInt(), dragOffset.y.roundToInt()) }
                        .size(80.dp)
                        .background(Color(0xFF2196F3))
                        .onGloballyPositioned { sourceBounds = it.boundsInRoot() }
                        .testTag("drag_source")
                        .pointerInput(Unit) {
                            detectDragGestures(
                                onDrag = { change, amount ->
                                    change.consume()
                                    dragOffset += amount
                                },
                                onDragEnd = {
                                    if (targetBounds.contains(sourceBounds.center)) {
                                        dragAccepted = true
                                        gestureCount++
                                    }
                                    dragOffset = Offset.Zero
                                },
                                onDragCancel = { dragOffset = Offset.Zero },
                            )
                        },
                    contentAlignment = Alignment.Center,
                ) {
                    Text("Drag", color = Color.White)
                }
                Box(
                    modifier = Modifier
                        .size(80.dp)
                        .background(if (dragAccepted) Color(0xFF69F0AE) else Color(0xFF4CAF50))
                        .onGloballyPositioned { targetBounds = it.boundsInRoot() }
                        .testTag("drag_target"),
                    contentAlignment = Alignment.Center,
                ) {
                    Text(if (dragAccepted) "Done!" else "Drop", color = Color.White)
                }
            }
            Spacer(Modifier.height(24.dp))

            SectionLabel("Double Tap")
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(80.dp)
                    .background(Color(0xFFFFE0B2))
                    .testTag("double_tap_area")
                    .pointerInput(Unit) {
                        detectTapGestures(onDoubleTap = {
                            doubleTapCount++
                            gestureCount++
                        })
                    },
                contentAlignment = Alignment.Center,
            ) {
                Text("Double taps: $doubleTapCount", fontSize = 16.sp)
            }
            Spacer(Modifier.height(24.dp))

            SectionLabel("Long Press")
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(80.dp)
                    .background(Color(0xFFE1BEE7))
                    .testTag("long_press_area")
                    .combinedClickable(
                        onClick = {},
                        onLongClick = {
                            gestureCount++
                            longPressMenuVisible = true
                        },
                    ),
                contentAlignment = Alignment.Center,
            ) {
                Text("Long press me", fontSize = 16.sp)
                DropdownMenu(
                    expanded = longPressMenuVisible,
                    onDismissRequest = { longPressMenuVisible = false },
                ) {
                    DropdownMenuItem(
                        text = { Text("Copy") },
                        onClick = { longPressMenuVisible = false },
                    )
                    DropdownMenuItem(
                        text = { Text("Delete") },
                        onClick = { longPressMenuVisible = false },
                    )
                }
            }
            Spacer(Modifier.height(24.dp))

            SectionLabel("Swipe Card")
            if (swipeCardVisible) {
                val dismissState = rememberSwipeToDismissBoxState(
                    confirmValueChange = { value ->
                        if (value != SwipeToDismissBoxValue.Settled) {
                            swipeCardVisible = false
                            gestureCount++
                            true
                        } else {
                            false
                        }
                    },
                )
                SwipeToDismissBox(
                    state = dismissState,
                    modifier = Modifier.testTag("swipe_card"),
                    backgroundContent = {
                        Box(
                            Modifier
                                .fillMaxSize()
                                .background(Color.Red)
                                .padding(end = 16.dp),
                            contentAlignment = Alignment.CenterEnd,
                        ) {
                            Icon(Icons.Filled.Delete, contentDescription = null, tint = Color.White)
                        }
                    },
                ) {
                    Card {
                        ListItem(
                            leadingContent = { Icon(Icons.Filled.Share, contentDescription = null) },
                            headlineContent = { Text("Swipe me to dismiss") },
                        )
                    }
                }
            } else {
                Text("Card dismissed!")
            }
        }
    }
}

@Composable
private fun SectionLabel(text: String) {
    Text(text, fontWeight = FontWeight.Bold)
    Spacer(Modifier.height(8.dp))
}
