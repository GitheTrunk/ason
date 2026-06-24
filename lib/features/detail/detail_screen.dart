import 'package:ason/features/detail/widgets/quick_action_button.dart';
import 'package:ason/providers/detail_provider.dart';
import 'package:ason/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({required this.id, super.key});

  final String id;

  IconData _getIcon(String type) {
    switch (type.toLowerCase()) {
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
        return Icons.location_on_rounded;
    }
  }

  Color _getColor(String type) {
    switch (type.toLowerCase()) {
      case 'hospital':
        return Colors.red.shade600;
      case 'police':
        return Colors.blue.shade700;
      case 'fire station':
        return Colors.orange.shade800;
      case 'ambulance':
        return Colors.green.shade600;
      case 'pharmacy':
        return Colors.teal.shade600;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(serviceByIdProvider(id));
    final lang = ref.watch(languageProvider);
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          strings.serviceDetails,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: serviceAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                strings.loadingServiceDetails,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        error: (error, _) => Center(
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
                  strings.failedToLoadDetails,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        data: (service) {
          if (service == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    strings.serviceNotFound,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final color = _getColor(service.typeEn);
          final icon = _getIcon(service.typeEn);
          final serviceName = service.localizedName(lang);
          final serviceType = service.localizedType(lang);
          final serviceAddress = service.localizedAddress(lang);
          final serviceDescription = service.localizedDescription(lang);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: color.withAlpha(15),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: color.withAlpha(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withAlpha(30),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: color, size: 48),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        serviceName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color.withAlpha(30),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              serviceType.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                service.rating.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Quick Actions Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    QuickActionButton(
                      label: strings.call,
                      icon: Icons.phone_rounded,
                      color: Colors.green.shade600,
                      onTap: () {},
                    ),
                    QuickActionButton(
                      label: strings.directions,
                      icon: Icons.map_rounded,
                      color: Colors.blue.shade600,
                      onTap: () {},
                    ),
                    QuickActionButton(
                      label: strings.favorite,
                      icon: Icons.favorite_rounded,
                      color: Colors.pink.shade600,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Information Section
                Text(
                  strings.information,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.phone_outlined,
                        strings.phoneNumber,
                        service.phone,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1),
                      ),
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        strings.address,
                        serviceAddress,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1),
                      ),
                      _buildInfoRow(
                        Icons.category_outlined,
                        strings.serviceType,
                        serviceType,
                      ),
                      if (serviceDescription.trim().isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1),
                        ),
                        _buildInfoRow(
                          Icons.description_outlined,
                          strings.description,
                          serviceDescription,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.grey.shade600, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1C1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
