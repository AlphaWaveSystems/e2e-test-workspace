package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.alphawavesystems.probe_test_app_native.data.AuthViewModel
import com.alphawavesystems.probe_test_app_native.navigation.Routes
import kotlinx.coroutines.launch

/// Twin of the Flutter app's LoginPage.
@Composable
fun LoginScreen(navController: NavController, auth: AuthViewModel) {
    var email by rememberSaveable { mutableStateOf("") }
    var password by rememberSaveable { mutableStateOf("") }
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    ScreenScaffold("Login", navController, snackbarHostState) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(24.dp),
        ) {
            Spacer(Modifier.height(48.dp))
            Icon(
                Icons.Filled.Lock,
                contentDescription = null,
                modifier = Modifier.size(80.dp).align(Alignment.CenterHorizontally),
                tint = MaterialTheme.colorScheme.primary,
            )
            Spacer(Modifier.height(32.dp))
            OutlinedTextField(
                value = email,
                onValueChange = { email = it },
                modifier = Modifier.fillMaxWidth().testTag("email_field"),
                label = { Text("Email") },
                placeholder = { Text("Enter your email") },
                leadingIcon = { Icon(Icons.Filled.Email, contentDescription = null) },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                singleLine = true,
            )
            Spacer(Modifier.height(16.dp))
            OutlinedTextField(
                value = password,
                onValueChange = { password = it },
                modifier = Modifier.fillMaxWidth().testTag("password_field"),
                label = { Text("Password") },
                placeholder = { Text("Enter your password") },
                leadingIcon = { Icon(Icons.Filled.Lock, contentDescription = null) },
                visualTransformation = PasswordVisualTransformation(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                singleLine = true,
            )
            Spacer(Modifier.height(8.dp))
            auth.error?.let { error ->
                Text(
                    error,
                    modifier = Modifier.padding(bottom = 8.dp).testTag("error_message"),
                    color = MaterialTheme.colorScheme.error,
                    fontSize = 14.sp,
                )
            }
            Spacer(Modifier.height(16.dp))
            if (auth.isLoading) {
                CircularProgressIndicator(
                    modifier = Modifier
                        .align(Alignment.CenterHorizontally)
                        .testTag("loading_indicator"),
                )
            } else {
                Button(
                    onClick = {
                        auth.login(email, password) {
                            navController.navigate(Routes.DASHBOARD) {
                                popUpTo(Routes.HOME)
                            }
                        }
                    },
                    modifier = Modifier.fillMaxWidth().testTag("sign_in_button"),
                ) {
                    Text("Sign In", fontSize = 16.sp)
                }
            }
            Spacer(Modifier.height(12.dp))
            TextButton(
                onClick = {
                    scope.launch {
                        snackbarHostState.showSnackbar("Password reset not implemented")
                    }
                },
                modifier = Modifier.align(Alignment.CenterHorizontally).testTag("forgot_password"),
            ) {
                Text("Forgot Password?")
            }
        }
    }
}
