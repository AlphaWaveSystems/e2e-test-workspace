package com.alphawavesystems.probe_test_app_native.navigation

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.alphawavesystems.probe_test_app_native.data.AuthViewModel
import com.alphawavesystems.probe_test_app_native.data.ItemsViewModel
import com.alphawavesystems.probe_test_app_native.data.SettingsViewModel
import com.alphawavesystems.probe_test_app_native.screens.ApiScreen
import com.alphawavesystems.probe_test_app_native.screens.BiometricLoginScreen
import com.alphawavesystems.probe_test_app_native.screens.DashboardScreen
import com.alphawavesystems.probe_test_app_native.screens.DeviceScreen
import com.alphawavesystems.probe_test_app_native.screens.DynamicScreen
import com.alphawavesystems.probe_test_app_native.screens.GesturesScreen
import com.alphawavesystems.probe_test_app_native.screens.HomeScreen
import com.alphawavesystems.probe_test_app_native.screens.ItemListScreen
import com.alphawavesystems.probe_test_app_native.screens.LoginScreen
import com.alphawavesystems.probe_test_app_native.screens.SettingsScreen
import com.alphawavesystems.probe_test_app_native.screens.SignalScreen
import com.alphawavesystems.probe_test_app_native.screens.VisualScreen

/// Route names mirror the Flutter app's Routes class (minus the leading '/').
object Routes {
    const val HOME = "home"
    const val LOGIN = "login"
    const val BIOMETRIC = "biometric"
    const val DASHBOARD = "dashboard"
    const val SETTINGS = "settings"
    const val ITEMS = "items"
    const val GESTURES = "gestures"
    const val API = "api"
    const val DEVICE = "device"
    const val VISUAL = "visual"
    const val DYNAMIC = "dynamic"
    const val SIGNAL = "signal"
}

@Composable
fun AppNavHost() {
    val navController = rememberNavController()

    // Activity-scoped view models — shared across destinations, surviving
    // navigation, exactly like the Flutter app's app-level Providers.
    val authViewModel: AuthViewModel = viewModel()
    val itemsViewModel: ItemsViewModel = viewModel()
    val settingsViewModel: SettingsViewModel = viewModel()

    NavHost(navController = navController, startDestination = Routes.HOME) {
        composable(Routes.HOME) { HomeScreen(navController) }
        composable(Routes.LOGIN) { LoginScreen(navController, authViewModel) }
        composable(Routes.BIOMETRIC) { BiometricLoginScreen(navController, authViewModel) }
        composable(Routes.DASHBOARD) { DashboardScreen(navController, authViewModel) }
        composable(Routes.SETTINGS) { SettingsScreen(navController, settingsViewModel) }
        composable(Routes.ITEMS) { ItemListScreen(navController, itemsViewModel) }
        composable(Routes.GESTURES) { GesturesScreen(navController) }
        composable(Routes.API) { ApiScreen(navController) }
        composable(Routes.DEVICE) { DeviceScreen(navController) }
        composable(Routes.VISUAL) { VisualScreen(navController) }
        composable(Routes.DYNAMIC) { DynamicScreen(navController) }
        composable(Routes.SIGNAL) { SignalScreen(navController) }
    }
}
