import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cashlens/core/providers/currency_provider.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
    
    // Initialize currency provider
    ref.read(currencyNotifierProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo/Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 60,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // App Name
                        Text(
                          'Cashlens',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Slogan
                        Text(
                          'See your money clearly',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 60),

                        // Features
                        _buildFeatureItem(
                          context,
                          Icons.trending_up,
                          'Track your expenses',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          context,
                          Icons.insights,
                          'Visualize your spending',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          context,
                          Icons.savings,
                          'Achieve your goals',
                        ),
                        const SizedBox(height: 60),

                        // Enter Button
                        SizedBox(
                          width: size.width > 600 ? 400 : double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/dashboard');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 8,
                              shadowColor: theme.colorScheme.primary.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login hint (for future)
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to login
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login feature coming soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            'Already have an account? Sign in',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
