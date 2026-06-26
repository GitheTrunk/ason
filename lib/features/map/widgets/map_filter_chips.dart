import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/map_provider.dart';

class MapFilterChips extends ConsumerWidget {
  const MapFilterChips({super.key});

  static const _filters = [
    _Filter(MapServiceType.all, Icons.layers_rounded),
    _Filter(MapServiceType.hospital, Icons.local_hospital_rounded),
    _Filter(MapServiceType.police, Icons.local_police_rounded),
    _Filter(MapServiceType.fireStation, Icons.fire_truck_rounded),
    _Filter(MapServiceType.ambulance, Icons.emergency_rounded),
    _Filter(MapServiceType.pharmacy, Icons.local_pharmacy_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(mapFilterProvider).selectedType;
    final strings = ref.watch(stringsProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = selectedType == filter.type;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterChip(
              filter: filter,
              isSelected: isSelected,
              label: filter.localizedLabel(strings),
              onTap: () =>
                  ref.read(mapFilterProvider.notifier).setFilter(filter.type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  final _Filter filter;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  Color get _chipColor {
    switch (filter.type) {
      case MapServiceType.hospital:
        return const Color(0xFFE53935);
      case MapServiceType.police:
        return const Color(0xFF1565C0);
      case MapServiceType.fireStation:
        return const Color(0xFFE65100);
      case MapServiceType.ambulance:
        return const Color(0xFF2E7D32);
      case MapServiceType.pharmacy:
        return const Color(0xFF00897B);
      default:
        return const Color(0xFF5C6BC0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _chipColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              filter.icon,
              size: 16,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filter {
  const _Filter(this.type, this.icon);
  final String type;
  final IconData icon;

  String localizedLabel(AppStrings strings) {
    switch (type) {
      case MapServiceType.hospital:
        return strings.hospital;
      case MapServiceType.police:
        return strings.police;
      case MapServiceType.fireStation:
        return strings.fireStation;
      case MapServiceType.ambulance:
        return strings.ambulance;
      case MapServiceType.pharmacy:
        return strings.pharmacy;
      default:
        return strings.all;
    }
  }
}
