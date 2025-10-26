import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../constants/app_constants.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'go_router_refresh_stream.dart';

/// WEDLY App Router
/// Handles all navigation routes with golden theme
class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: AppConstants.routeSplash,
      redirect: (context, state) async {
        // Get AuthBloc from context
        final authBloc = context.read<AuthBloc>();
        final authState = authBloc.state;
        
        // Check if user is trying to access auth pages
        final isAuthRoute = state.matchedLocation.startsWith(AppConstants.routeAuth);
        
        // If user is authenticated and trying to access auth pages, redirect to home
        if (authState is AuthAuthenticated && isAuthRoute) {
          return AppConstants.routeHome;
        }
        
        // If user is not authenticated and trying to access protected pages, redirect to login
        if (authState is! AuthAuthenticated && !isAuthRoute) {
          return AppConstants.routeAuth;
        }
        
        // Allow navigation
        return null;
      },
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
    routes: [
      // Splash Screen Route
      GoRoute(
        path: AppConstants.routeSplash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding Route
      GoRoute(
        path: AppConstants.routeOnboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Home Route
      GoRoute(
        path: AppConstants.routeHome,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // Authentication Routes (Outside main navigation)
      GoRoute(
        path: AppConstants.routeAuth,
        name: 'auth',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
          ),
        ],
      ),
      
      // Service Detail Route
      GoRoute(
        path: '${AppConstants.routeServiceDetail}/:id',
        name: 'service-detail',
        builder: (context, state) {
          final serviceId = state.pathParameters['id']!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Service Details'),
            ),
            body: Center(
              child: Text('Service ID: $serviceId'),
            ),
          );
        },
      ),
      
      // Booking Route
      GoRoute(
        path: '${AppConstants.routeBooking}/:serviceId',
        name: 'booking',
        builder: (context, state) {
          final serviceId = state.pathParameters['serviceId']!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Booking'),
            ),
            body: Center(
              child: Text('Booking for Service ID: $serviceId'),
            ),
          );
        },
      ),
      
      // Search Route
      GoRoute(
        path: AppConstants.routeSearch,
        name: 'search',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Search Page - Coming Soon'),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.routeHome),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    );
  }
}