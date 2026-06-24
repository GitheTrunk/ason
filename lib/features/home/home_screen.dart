import 'package:ason/features/home/widgets/service_card.dart';
import 'package:ason/features/home/widgets/category_button.dart';
import 'package:ason/features/home/widgets/sos_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/language_provider.dart';
import '../../providers/emergency_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final strings = ref.watch(stringsProvider);

    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.greeting,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'ASON',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
              ),
            ),

            // Search Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(
                          theme.brightness == Brightness.dark ? 30 : 5,
                        ),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: strings.searchEmergency,
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
            ),
            // SOS Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    SOSButton(onTap: () {}),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Quick Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CategoryButton(
                        label: strings.hospital,
                        icon: Icons.local_hospital_rounded,
                        color: Colors.red.shade600,
                        onTap: () {},
                      ),
                      CategoryButton(
                        label: strings.police,
                        icon: Icons.local_police_rounded,
                        color: Colors.blue.shade700,
                        onTap: () {},
                      ),
                      CategoryButton(
                        label: strings.fireStation,
                        icon: Icons.fire_truck_rounded,
                        color: Colors.orange.shade800,
                        onTap: () {},
                      ),
                      CategoryButton(
                        label: strings.ambulance,
                        icon: Icons.emergency_rounded,
                        color: Colors.green.shade700,
                        onTap: () {},
                      ),
                      CategoryButton(
                        label: strings.pharmacy,
                        icon: Icons.local_pharmacy_rounded,
                        color: Colors.teal.shade600,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Nearby Services Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      strings.nearbyServices,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        strings.seeAll,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            servicesAsync.when(
              loading: () => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        strings.searchingServices,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Colors.red.shade200,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strings.somethingWentWrong,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              data: (services) {
                if (services.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            strings.noServicesFound,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ServiceCard(service: services[index]),
                      );
                    }, childCount: services.length),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
