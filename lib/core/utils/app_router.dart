import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../shared/widgets/main_navigation_wrapper.dart';
import '../../features/feedback/feedback_page.dart';
import '../constants/app_constants.dart';

/// WEDLY App Router
/// Handles all navigation routes with golden theme
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppConstants.routeHome,
    routes: [
      // Main Navigation Wrapper
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationWrapper(child: child);
        },
        routes: [
          // Home Route
          GoRoute(
            path: AppConstants.routeHome,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          
          // Vendors Route
          GoRoute(
            path: AppConstants.routeVendors,
            name: 'vendors',
            builder: (context, state) => const Scaffold(
              body: Center(
                child: Text('Vendors Page - Coming Soon'),
              ),
            ),
          ),
          
          // Quick Book Route
          GoRoute(
            path: AppConstants.routeQuickBook,
            name: 'quick-book',
            builder: (context, state) => const Scaffold(
              body: Center(
                child: Text('Quick Book Page - Coming Soon'),
              ),
            ),
          ),
          
          // Feedback Route
          GoRoute(
            path: AppConstants.routeFeedback,
            name: 'feedback',
            builder: (context, state) => const FeedbackPage(),
          ),
          
          // Profile Route
          GoRoute(
            path: AppConstants.routeProfile,
            name: 'profile',
            builder: (context, state) => const Scaffold(
              body: Center(
                child: Text('Profile Page - Coming Soon'),
              ),
            ),
          ),
        ],
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
  
  static GoRouter get router => _router;
}