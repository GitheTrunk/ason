import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../providers/map_provider.dart';
import 'widgets/map_filter_chips.dart';
import 'widgets/service_detail_sheet.dart';
import 'widgets/service_marker.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  late final MapController _mapController;

  // Default center: Phnom Penh, Cambodia
  static const _defaultCenter = LatLng(11.5564, 104.9282);
  static const _defaultZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _animateTo(LatLng target, {double zoom = 15.0}) {
    _mapController.move(target, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredServicesProvider);
    final selectedService = ref.watch(selectedServiceProvider);
    final filterState = ref.watch(mapFilterProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ── Map ────────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultCenter,
              initialZoom: _defaultZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: (tapPosition, point) {
                ref.read(mapFilterProvider.notifier).clearSelection();
              },
            ),
            children: [
              // Base tile layer (OpenStreetMap)
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ason',
              ),

              // Markers
              MarkerLayer(
                markers: filteredAsync.when(
                  data: (services) => services.map((service) {
                    final isSelected =
                        filterState.selectedServiceId == service.id;
                    return Marker(
                      point: LatLng(service.latitude, service.longitude),
                      width: 56,
                      height: 56,
                      child: ServiceMarker(
                        type: service.type,
                        isSelected: isSelected,
                        onTap: () {
                          ref
                              .read(mapFilterProvider.notifier)
                              .selectService(service.id);
                          _animateTo(
                            LatLng(service.latitude, service.longitude),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  loading: () => [],
                  error: (err, st) => [],
                ),
              ),
            ],
          ),

          // ── Top bar ────────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Header card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(18),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.map_rounded,
                          color: Color(0xFF5C6BC0),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Emergency Services Map',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1C1E),
                            ),
                          ),
                        ),
                        filteredAsync.when(
                          data: (services) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5C6BC0).withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${services.length} found',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF5C6BC0),
                              ),
                            ),
                          ),
                          loading: () => const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          error: (err, st) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter chips
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(220),
                    ),
                    child: const MapFilterChips(),
                  ),
                ),
              ],
            ),
          ),

          // ── Loading overlay ────────────────────────────────────────────────
          if (filteredAsync.isLoading)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF5C6BC0)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Loading services...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Error state ────────────────────────────────────────────────────
          if (filteredAsync.hasError)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEF9A9A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFE53935)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Failed to load services. Check your connection.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB71C1C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Re-center FAB ──────────────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: selectedService != null ? 240 : 100,
            child: FloatingActionButton.small(
              heroTag: 'recenter',
              onPressed: () => _animateTo(_defaultCenter, zoom: _defaultZoom),
              backgroundColor: Colors.white,
              elevation: 4,
              child: const Icon(
                Icons.my_location_rounded,
                color: Color(0xFF5C6BC0),
              ),
            ),
          ),

          // ── Service Detail Sheet ───────────────────────────────────────────
          if (selectedService != null)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: AnimatedSlide(
                offset: Offset.zero,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: ServiceDetailSheet(
                    service: selectedService,
                    onClose: () =>
                        ref.read(mapFilterProvider.notifier).clearSelection(),
                    onNavigate: () => _animateTo(
                      LatLng(
                        selectedService.latitude,
                        selectedService.longitude,
                      ),
                      zoom: 17,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
