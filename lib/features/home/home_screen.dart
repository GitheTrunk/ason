import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/emergency_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ASON')),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stackTrace) => Center(child: Text(error.toString())),

        data: (services) {
          if (services.isEmpty) {
            return const Center(child: Text('No emergency services found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final service = services[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(service.type.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(service.name),
                  subtitle: Text(service.phone),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
