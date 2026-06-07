import 'package:flutter/material.dart';

class FirstAidCard extends StatelessWidget {
  final String title;
  final String category;
  final VoidCallback onTap;

  const FirstAidCard({
    super.key,
    required this.title,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(category),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
