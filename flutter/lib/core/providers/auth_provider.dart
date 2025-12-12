import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Authentication state model
class AuthState {
  final bool isAuthenticated;
  final String? username;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.username,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? username,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Authentication provider
@riverpod
class Auth extends _$Auth {
  // Demo credentials
  static const String _demoUsername = 'admin';
  static const String _demoPassword = 'admin';

  @override
  AuthState build() {
    return const AuthState();
  }

  /// Login with username and password
  /// For now, only accepts admin:admin
  Future<bool> login(String username, String password) async {
    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check credentials
    if (username == _demoUsername && password == _demoPassword) {
      state = state.copyWith(
        isAuthenticated: true,
        username: username,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: 'Invalid username or password',
      );
      return false;
    }
  }

  /// Register a new user
  /// For now, always returns success but does nothing
  Future<bool> register(String username, String password, String email) async {
    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Always return success
    state = state.copyWith(
      isLoading: false,
    );

    return true;
  }

  /// Logout
  void logout() {
    state = const AuthState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
