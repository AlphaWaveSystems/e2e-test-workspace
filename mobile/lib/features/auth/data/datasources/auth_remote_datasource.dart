import '../../../../core/error/failures.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  /// Simulates a remote login call.
  ///
  /// Accepted credentials:
  /// - test@test.com / password
  /// - admin@test.com / admin123
  ///
  /// Throws [AuthFailure] for invalid credentials.
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@test.com' && password == 'password') {
      return const UserModel(
        id: 1,
        name: 'Test User',
        email: 'test@test.com',
      );
    }

    if (email == 'admin@test.com' && password == 'admin123') {
      return const UserModel(
        id: 2,
        name: 'Admin User',
        email: 'admin@test.com',
      );
    }

    throw const AuthFailure('Invalid email or password');
  }
}
