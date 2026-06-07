import 'package:ason/providers/first_aid_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/first_aid_guide.dart';
import '../widgets/first_aid_card.dart';
import 'first_aid_detail_screen.dart';

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
    return guides.where((guide) {
      final matchesSearch = guide.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesCategory =
          selectedCategory == 'All' || guide.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final guidesAsync = ref.watch(firstAidProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('First Aid')),
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
                        title: guide.title,
                        category: guide.category,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search first aid guides...',
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
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category),
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
    );
  }
}
