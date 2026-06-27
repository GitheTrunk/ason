import 'package:flutter/material.dart';

import '../../../models/first_aid_guide.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final FirstAidGuide guide;

  const FirstAidDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                guide.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: guide.imageUrl.isNotEmpty
                  ? Image.network(
                      guide.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryChip(theme),

                  const SizedBox(height: 24),

                  Text(
                    'First Aid Steps',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (guide.steps.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('No steps available.'),
                      ),
                    )
                  else
                    ...guide.steps.asMap().entries.map(
                      (entry) => _buildStepCard(
                        theme: theme,
                        number: entry.key + 1,
                        text: entry.value,
                      ),
                    ),

                  const SizedBox(height: 30),

                  _buildEmergencySection(theme),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.red.shade100,
      child: const Center(child: Icon(Icons.health_and_safety, size: 80)),
    );
  }

  Widget _buildCategoryChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        guide.category,
        style: TextStyle(
          color: theme.colorScheme.onErrorContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required ThemeData theme,
    required int number,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: Text(number.toString()),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.emergency, size: 40, color: theme.colorScheme.error),

          const SizedBox(height: 12),

          Text(
            'Emergency?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'If the condition is serious, contact emergency services immediately.',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onErrorContainer),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: const Text('Call Emergency'),
              onPressed: () {
                // TODO
                // launchUrl(
                // Uri.parse('tel:119')
                // );
              },
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.local_hospital),
              label: const Text('Nearby Hospitals'),
              onPressed: () {
                // TODO
                // Navigate to hospital screen
              },
            ),
          ),
        ],
      ),
    );
  }
}
