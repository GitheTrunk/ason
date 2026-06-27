import 'package:ason/providers/first_aid_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/first_aid_guide.dart';
import '../widgets/first_aid_card.dart';
import 'first_aid_detail_screen.dart';
import '../../../providers/settings_provider.dart';

class FirstAidScreen extends ConsumerStatefulWidget {
  const FirstAidScreen({super.key});

  @override
  ConsumerState<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends ConsumerState<FirstAidScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final categories = [
    'All',
    'Life Saving',
    'Injury',
    'Environmental',
    'Animal Related',
  ];

  List<FirstAidGuide> _filterGuides(List<FirstAidGuide> guides) {
    final lang =
        ref.read(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';
    return guides.where((guide) {
      final localizedTitle = guide.localizedTitle(lang).toLowerCase();

      final matchesSearch = localizedTitle.contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == 'All' || guide.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final guidesAsync = ref.watch(firstAidProvider);
    final settings = ref.watch(settingsProvider);
    final lang = settings.whenOrNull(data: (s) => s.language) ?? 'en';
    final isKh = lang == 'km' || lang == 'kh';

    return Scaffold(
      appBar: AppBar(title: Text(isKh ? 'ជំនួយដំបូង' : 'First Aid')),
      body: guidesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, stackTrace) => Center(child: Text(error.toString())),

        data: (guides) {
          final filteredGuides = _filterGuides(guides);

          return Column(
            children: [
              _buildSearchBar(),
              _buildCategoryFilter(),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredGuides.length,
                  itemBuilder: (context, index) {
                    final guide = filteredGuides[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FirstAidCard(
                        title: guide.localizedTitle(lang),
                        category: guide.localizedCategory(lang),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FirstAidDetailScreen(guide: guide),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    final lang =
        ref.watch(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';
    final isKh = lang == 'km' || lang == 'kh';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: isKh
              ? 'ស្វែងរកមគ្គុទេសក៍ជំនួយដំបូង...'
              : 'Search first aid guides...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final lang =
        ref.watch(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';
    final isKh = lang == 'km' || lang == 'kh';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SizedBox(
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final label = switch (category) {
              'All' => isKh ? 'ទាំងអស់' : 'All',
              'Life Saving' => isKh ? 'សង្គ្រោះជីវិត' : 'Life Saving',
              'Injury' => isKh ? 'របួស' : 'Injury',
              'Environmental' => isKh ? 'បរិស្ថាន' : 'Environmental',
              'Animal Related' => isKh ? 'ពាក់ព័ន្ធនឹងសត្វ' : 'Animal Related',
              _ => category,
            };

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: selectedCategory == category,
                onSelected: (_) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
