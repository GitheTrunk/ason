import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/first_aid_guide.dart';
import '../../../providers/settings_provider.dart';

class FirstAidDetailScreen extends ConsumerWidget {
  final FirstAidGuide guide;

  const FirstAidDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang =
        ref.watch(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';
    final isKh = lang == 'km' || lang == 'kh';
    final title = guide.localizedTitle(lang);
    final category = guide.localizedCategory(lang);
    final steps = guide.localizedSteps(lang);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                  _buildCategoryChip(theme, category),

                  const SizedBox(height: 24),

                  Text(
                    isKh ? 'ជំហានជំនួយដំបូង' : 'First Aid Steps',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (steps.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          isKh ? 'មិនមានជំហានទេ។' : 'No steps available.',
                        ),
                      ),
                    )
                  else
                    ...steps.asMap().entries.map(
                      (entry) => _buildStepCard(
                        theme: theme,
                        number: entry.key + 1,
                        text: entry.value,
                      ),
                    ),

                  const SizedBox(height: 30),

                  _buildEmergencySection(theme, isKh),

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

  Widget _buildCategoryChip(ThemeData theme, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
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

  Widget _buildEmergencySection(ThemeData theme, bool isKh) {
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
            isKh ? 'បន្ទាន់?' : 'Emergency?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            isKh
                ? 'បើស្ថានភាពធ្ងន់ធ្ងរ សូមទាក់ទងសេវាបន្ទាន់ភ្លាមៗ។'
                : 'If the condition is serious, contact emergency services immediately.',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onErrorContainer),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: Text(isKh ? 'ហៅបន្ទាន់' : 'Call Emergency'),
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
              label: Text(isKh ? 'មន្ទីរពេទ្យជិតខាង' : 'Nearby Hospitals'),
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
