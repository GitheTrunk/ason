import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/map_provider.dart';

class MapFilterChips extends ConsumerWidget {
  const MapFilterChips({super.key});

  static const _filters = [
    _Filter('All', Icons.layers_rounded),
    _Filter('Hospital', Icons.local_hospital_rounded),
    _Filter('Police', Icons.local_police_rounded),
    _Filter('Fire Station', Icons.fire_truck_rounded),
    _Filter('Ambulance', Icons.emergency_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(mapFilterProvider).selectedType;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = selectedType == filter.label;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterChip(
              filter: filter,
              isSelected: isSelected,
              onTap: () =>
                  ref.read(mapFilterProvider.notifier).setFilter(filter.label),
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
    required this.onTap,
  });

  final _Filter filter;
  final bool isSelected;
  final VoidCallback onTap;

  Color get _chipColor {
    switch (filter.label) {
      case 'Hospital':
        return const Color(0xFFE53935);
      case 'Police':
        return const Color(0xFF1565C0);
      case 'Fire Station':
        return const Color(0xFFE65100);
      case 'Ambulance':
        return const Color(0xFF2E7D32);
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
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
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
              filter.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
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
  const _Filter(this.label, this.icon);
  final String label;
  final IconData icon;
}
