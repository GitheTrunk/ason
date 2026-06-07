import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'First Aid',
      subtitle: 'Emergency guides and life-saving instructions',
    );
  }
}
