import 'package:cashlens/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
// ignore: deprecated_member_use_from_same_package
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
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
