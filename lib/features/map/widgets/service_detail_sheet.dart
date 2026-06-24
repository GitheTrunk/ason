import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/emergency_service.dart';
import '../../../providers/language_provider.dart';

class ServiceDetailSheet extends ConsumerWidget {
  const ServiceDetailSheet({
    super.key,
    required this.service,
    required this.onClose,
    required this.onNavigate,
    required this.onViewDetails,
  });

  final EmergencyService service;
  final VoidCallback onClose;
  final VoidCallback onNavigate;
  final VoidCallback onViewDetails;

  Color get _typeColor {
    switch (service.typeEn.toLowerCase()) {
      case 'hospital':
        return const Color(0xFFE53935);
      case 'police':
        return const Color(0xFF1565C0);
      case 'fire station':
        return const Color(0xFFE65100);
      case 'ambulance':
        return const Color(0xFF2E7D32);
      case 'pharmacy':
        return const Color(0xFF00897B);
      default:
        return const Color(0xFF5C6BC0);
    }
  }

  IconData get _typeIcon {
    switch (service.typeEn.toLowerCase()) {
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'police':
        return Icons.local_police_rounded;
      case 'fire station':
        return Icons.fire_truck_rounded;
      case 'ambulance':
        return Icons.emergency_rounded;
      case 'pharmacy':
        return Icons.local_pharmacy_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final strings = ref.watch(stringsProvider);
    final serviceName = service.localizedName(lang);
    final serviceType = service.localizedType(lang);
    final serviceAddress = service.localizedAddress(lang);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle + close button
            Row(
              children: [
                const Spacer(),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Type badge + Name row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _typeColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_typeIcon, color: _typeColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _typeColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          serviceType,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _typeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFA000),
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // Address
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: serviceAddress,
              iconColor: const Color(0xFF5C6BC0),
            ),
            const SizedBox(height: 10),

            // Phone
            _InfoRow(
              icon: Icons.phone_outlined,
              text: service.phone,
              iconColor: const Color(0xFF2E7D32),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.call_rounded,
                    label: strings.call,
                    color: const Color(0xFF2E7D32),
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.directions_rounded,
                    label: strings.directions,
                    color: const Color(0xFF1565C0),
                    onTap: onNavigate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.info_outline_rounded,
                    label: strings.viewDetails,
                    color: const Color(0xFF5C6BC0),
                    onTap: onViewDetails,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
