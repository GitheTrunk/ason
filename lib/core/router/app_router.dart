import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/booking/booking_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/detail/detail_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/nearby/nearby_screen.dart';
import '../../features/promotions/promotions_screen.dart';
import '../../features/reviews/reviews_screen.dart';
import '../../features/settings/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/nearby',
        name: 'nearby',
        builder: (context, state) => const NearbyScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        builder: (context, state) => const ReviewsScreen(),
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/promotions',
        name: 'promotions',
        builder: (context, state) => const PromotionsScreen(),
      ),
      GoRoute(
        path: '/gallery',
        name: 'gallery',
        builder: (context, state) => const GalleryScreen(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
