import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/emergency_service.dart';
import 'emergency_provider.dart';

// ─── Filter State ────────────────────────────────────────────────────────────

class MapFilterState {
  const MapFilterState({
    this.selectedType = MapServiceType.all,
    this.selectedServiceId,
  });

  final String selectedType;
  final String? selectedServiceId;

  MapFilterState copyWith({
    String? selectedType,
    String? selectedServiceId,
    bool clearSelected = false,
  }) {
    return MapFilterState(
      selectedType: selectedType ?? this.selectedType,
      selectedServiceId: clearSelected
          ? null
          : selectedServiceId ?? this.selectedServiceId,
    );
  }
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class MapFilterNotifier extends Notifier<MapFilterState> {
  @override
  MapFilterState build() => const MapFilterState();

  void setFilter(String type) {
    state = state.copyWith(selectedType: type, clearSelected: true);
  }

  void selectService(String? id) {
    state = state.copyWith(selectedServiceId: id);
  }

  void clearSelection() {
    state = state.copyWith(clearSelected: true);
  }
}

final mapFilterProvider = NotifierProvider<MapFilterNotifier, MapFilterState>(
  MapFilterNotifier.new,
);

// ─── Derived providers ───────────────────────────────────────────────────────

/// All services loaded from Supabase (re-uses the existing provider).
final allServicesProvider = servicesProvider;

/// Services filtered by the active map filter type.
final filteredServicesProvider = Provider<AsyncValue<List<EmergencyService>>>((
  ref,
) {
  final allAsync = ref.watch(allServicesProvider);
  final filter = ref.watch(mapFilterProvider);

  return allAsync.whenData((services) {
    if (filter.selectedType == MapServiceType.all) return services;
    return services
        .where((s) => s.typeEn.toLowerCase() == filter.selectedType)
        .toList();
  });
});

/// The currently selected/tapped service.
final selectedServiceProvider = Provider<EmergencyService?>((ref) {
  final allAsync = ref.watch(allServicesProvider);
  final filter = ref.watch(mapFilterProvider);

  if (filter.selectedServiceId == null) return null;

  return allAsync.whenData((services) {
    try {
      return services.firstWhere((s) => s.id == filter.selectedServiceId);
    } catch (_) {
      return null;
    }
  }).value;
});

abstract final class MapServiceType {
  static const all = 'all';
  static const hospital = 'hospital';
  static const police = 'police';
  static const fireStation = 'fire station';
  static const ambulance = 'ambulance';
  static const pharmacy = 'pharmacy';
}
