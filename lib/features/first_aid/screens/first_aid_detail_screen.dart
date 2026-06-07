import 'package:flutter/material.dart';

import '../../../models/first_aid_guide.dart';

class FirstAidDetailScreen extends StatelessWidget {
  final FirstAidGuide guide;

  const FirstAidDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _buildCategoryChip(),

                  const SizedBox(height: 24),

                  const Text(
                    'First Aid Steps',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                        number: entry.key + 1,
                        text: entry.value,
                      ),
                    ),

                  const SizedBox(height: 30),

                  _buildEmergencySection(),

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

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        guide.category,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStepCard({required int number, required String text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, child: Text(number.toString())),

          const SizedBox(width: 12),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.emergency, size: 40, color: Colors.red),

          const SizedBox(height: 12),

          const Text(
            'Emergency?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'If the condition is serious, contact emergency services immediately.',
            textAlign: TextAlign.center,
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
