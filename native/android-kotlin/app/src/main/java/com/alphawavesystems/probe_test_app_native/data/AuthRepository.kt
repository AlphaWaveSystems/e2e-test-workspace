package com.alphawavesystems.probe_test_app_native.data

import kotlinx.coroutines.delay

data class User(
    val id: Int,
    val email: String,
    val name: String,
)

class AuthFailure(message: String) : Exception(message)

/// Mirrors the Flutter app's AuthRemoteDatasource: simulated remote login
/// with a 1 second network delay and two hardcoded credential pairs.
object AuthRepository {
    /// Accepted credentials:
    /// - test@test.com / password   -> Test User
    /// - admin@test.com / admin123  -> Admin User
    ///
    /// Throws [AuthFailure] for anything else.
    suspend fun login(email: String, password: String): User {
        delay(1000)

        if (email == "test@test.com" && password == "password") {
            return User(id = 1, email = "test@test.com", name = "Test User")
        }
        if (email == "admin@test.com" && password == "admin123") {
            return User(id = 2, email = "admin@test.com", name = "Admin User")
        }
        throw AuthFailure("Invalid email or password")
    }
}
