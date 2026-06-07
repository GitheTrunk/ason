import 'package:flutter/material.dart';
import '../../widgets/placeholder_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Emergency Contacts',
      subtitle: 'Manage the people who will be notified in case of an emergency.',
    );
  }
}
