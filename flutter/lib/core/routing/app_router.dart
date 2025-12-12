import 'package:cashlens/features/auth/presentation/landing_page.dart';
import 'package:cashlens/features/auth/presentation/login_page.dart';
import 'package:cashlens/features/auth/presentation/register_page.dart';
import 'package:cashlens/features/dashboard/presentation/dashboard_screen.dart';
import 'package:cashlens/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
GoRouter goRouter(GoRouterRef ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isOnLoginPage = state.matchedLocation == '/login';
      final isOnRegisterPage = state.matchedLocation == '/register';
      final isOnLandingPage = state.matchedLocation == '/';

      // If not authenticated and trying to access protected routes
      if (!isAuthenticated && !isOnLoginPage && !isOnRegisterPage && !isOnLandingPage) {
        return '/login';
      }

      // If authenticated and on login/register page, redirect to dashboard
      if (isAuthenticated && (isOnLoginPage || isOnRegisterPage)) {
        return '/dashboard';
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/transactions',
        name: 'transactions',
        builder: (context, state) => const Placeholder(), // TODO: Transactions
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const Placeholder(), // TODO: Categories
      ),
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const Placeholder(), // TODO: Statistics
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const Placeholder(), // TODO: Settings
      ),
    ],
  );
}
