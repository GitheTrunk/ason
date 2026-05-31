import 'package:flutter/material.dart';

import '../../widgets/placeholder_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: 'Service Detail',
      subtitle: 'Service ID: $id',
    );
  }
}
