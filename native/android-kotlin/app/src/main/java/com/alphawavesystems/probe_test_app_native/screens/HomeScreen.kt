package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.automirrored.filled.List
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Face
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.alphawavesystems.probe_test_app_native.navigation.Routes

/// Twin of the Flutter app's HomePage: 3-tab shell (Home / Tests / About)
/// with the Home tab hosting the navigation list to every other screen.
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(navController: NavController) {
    var currentTab by rememberSaveable { mutableIntStateOf(0) }

    Scaffold(
        topBar = { TopAppBar(title = { Text("FlutterProbe Test App") }) },
        bottomBar = {
            NavigationBar {
                NavigationBarItem(
                    modifier = Modifier.testTag("tab_home"),
                    selected = currentTab == 0,
                    onClick = { currentTab = 0 },
                    icon = {
                        Icon(
                            Icons.Filled.Home,
                            contentDescription = null,
                            modifier = Modifier.testTag("tab_home_icon"),
                        )
                    },
                    label = { Text("Home") },
                )
                NavigationBarItem(
                    modifier = Modifier.testTag("tab_tests"),
                    selected = currentTab == 1,
                    onClick = { currentTab = 1 },
                    icon = {
                        Icon(
                            Icons.Filled.Star,
                            contentDescription = null,
                            modifier = Modifier.testTag("tab_tests_icon"),
                        )
                    },
                    label = { Text("Tests") },
                )
                NavigationBarItem(
                    modifier = Modifier.testTag("tab_about"),
                    selected = currentTab == 2,
                    onClick = { currentTab = 2 },
                    icon = {
                        Icon(
                            Icons.Filled.Info,
                            contentDescription = null,
                            modifier = Modifier.testTag("tab_about_icon"),
                        )
                    },
                    label = { Text("About") },
                )
            }
        },
    ) { padding ->
        Box(Modifier.padding(padding).fillMaxSize()) {
            when (currentTab) {
                1 -> Text(
                    "Test Suites",
                    modifier = Modifier.align(Alignment.Center).testTag("tests_tab_content"),
                    fontSize = 18.sp,
                )
                2 -> Text(
                    "About FlutterProbe Test App",
                    modifier = Modifier.align(Alignment.Center).testTag("about_tab_content"),
                    fontSize = 18.sp,
                )
                else -> HomeTabContent(navController)
            }
        }
    }
}

@Composable
private fun HomeTabContent(navController: NavController) {
    Column(Modifier.fillMaxSize()) {
        Text(
            "Welcome to the FlutterProbe Test App",
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp)
                .testTag("welcome_text"),
            fontSize = 20.sp,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Center,
        )
        LazyColumn(Modifier.weight(1f)) {
            item { NavTile("Login", Icons.Filled.Lock, Routes.LOGIN, "nav_login", navController) }
            item { NavTile("Biometric Login", Icons.Filled.Face, Routes.BIOMETRIC, "nav_biometric", navController) }
            item { NavTile("Signal Demo", Icons.Filled.Notifications, Routes.SIGNAL, "nav_signal", navController) }
            item { NavTile("Dashboard", Icons.Filled.CheckCircle, Routes.DASHBOARD, "nav_dashboard", navController) }
            item { NavTile("Settings", Icons.Filled.Settings, Routes.SETTINGS, "nav_settings", navController) }
            item { NavTile("Items", Icons.AutoMirrored.Filled.List, Routes.ITEMS, "nav_items", navController) }
            item { NavTile("Gestures", Icons.Filled.ThumbUp, Routes.GESTURES, "nav_gestures", navController) }
            item { NavTile("API Tests", Icons.Filled.Person, Routes.API, "nav_api", navController) }
            item { NavTile("Device", Icons.Filled.LocationOn, Routes.DEVICE, "nav_device", navController) }
            item { NavTile("Visual", Icons.Filled.AccountCircle, Routes.VISUAL, "nav_visual", navController) }
            item { NavTile("Dynamic", Icons.Filled.Star, Routes.DYNAMIC, "nav_dynamic", navController) }
        }
        Text(
            "Version 1.0",
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp)
                .testTag("version_text"),
            color = Color.Gray,
            fontSize = 12.sp,
            textAlign = TextAlign.Center,
        )
    }
}

@Composable
private fun NavTile(
    title: String,
    icon: ImageVector,
    route: String,
    tag: String,
    navController: NavController,
) {
    ListItem(
        modifier = Modifier
            .testTag(tag)
            .clickable { navController.navigate(route) },
        leadingContent = { Icon(icon, contentDescription = null) },
        headlineContent = { Text(title) },
        trailingContent = {
            Icon(Icons.AutoMirrored.Filled.KeyboardArrowRight, contentDescription = null)
        },
        colors = androidx.compose.material3.ListItemDefaults.colors(
            containerColor = MaterialTheme.colorScheme.surface,
        ),
    )
}
