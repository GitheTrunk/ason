import 'package:flutter/material.dart';

class ServiceMarker extends StatelessWidget {
  const ServiceMarker({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  Color get _color {
    switch (type.toLowerCase()) {
      case 'hospital':
        return const Color(0xFFE53935);
      case 'police':
        return const Color(0xFF1565C0);
      case 'fire station':
        return const Color(0xFFE65100);
      case 'ambulance':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF5C6BC0);
    }
  }

  IconData get _icon {
    switch (type.toLowerCase()) {
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'police':
        return Icons.local_police_rounded;
      case 'fire station':
        return Icons.fire_truck_rounded;
      case 'ambulance':
        return Icons.emergency_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final size = isSelected ? 52.0 : 40.0;
    final iconSize = isSelected ? 22.0 : 18.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(isSelected ? 100 : 50),
              blurRadius: isSelected ? 12 : 6,
              spreadRadius: isSelected ? 2 : 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _icon,
          size: iconSize,
          color: isSelected ? Colors.white : color,
        ),
      ),
    );
  }
}
