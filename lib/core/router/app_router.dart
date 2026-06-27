import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/verify_otp_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/contacts/contacts_screen.dart';
import '../../features/detail/detail_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/first_aid/screens/first_aid_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/navigation/main_shell.dart';
import '../../features/nearby/nearby_screen.dart';
import '../../features/promotions/promotions_screen.dart';
import '../../features/reviews/reviews_screen.dart';
import '../../features/settings/privacy_policy_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/edit_profile_screen.dart';
import '../../features/settings/terms_service_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/repository_providers.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<bool>(false);

  ref.listen(authStateProvider, (_, __) {
    authNotifier.value = !authNotifier.value;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final user = ref.read(authRepositoryProvider).currentUser;
      final isLoggedIn = user != null;
      final path = state.uri.path;
      final isAuthRoute =
          path == '/login' || path == '/register' || path == '/verify-otp';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: '/contacts',
            name: 'contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: '/first-aid',
            name: 'first-aid',
            builder: (context, state) => const FirstAidScreen(),
          ),
        ],
      ),
      GoRoute(path: '/', redirect: (_, state) => '/home'),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/verify-otp',
        name: 'verify-otp',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return VerifyOtpScreen(email: email);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/nearby',
        name: 'nearby',
        builder: (context, state) => const NearbyScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/promotions',
        name: 'promotions',
        builder: (context, state) => const PromotionsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailScreen(id: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/reviews/:serviceId',
        name: 'reviews',
        builder: (context, state) {
          final serviceId = state.pathParameters['serviceId']!;
          return ReviewsScreen(serviceId: serviceId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/gallery',
        name: 'gallery',
        builder: (context, state) => const GalleryScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/privacy-policy',
        name: 'privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/terms-of-service',
        name: 'terms-of-service',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],
  );
});
