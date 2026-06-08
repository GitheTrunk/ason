import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/personal_contact.dart';
import '../repositories/personal_contact_repository.dart';
import 'repository_providers.dart';

final contactsProvider =
    FutureProvider<List<PersonalContact>>((ref) async {
  return ref.watch(personalContactRepositoryProvider).getContacts();
});

class ContactsNotifier extends AsyncNotifier<List<PersonalContact>> {
  PersonalContactRepository get _repo =>
      ref.read(personalContactRepositoryProvider);

  @override
  Future<List<PersonalContact>> build() =>
      ref.watch(personalContactRepositoryProvider).getContacts();

  Future<void> add(PersonalContact contact) async {
    await _repo.addContact(contact);
    ref.invalidateSelf();
  }

  Future<void> edit(PersonalContact contact) async {
    await _repo.updateContact(contact);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await _repo.deleteContact(id);
    ref.invalidateSelf();
  }
}

final contactsNotifierProvider =
    AsyncNotifierProvider<ContactsNotifier, List<PersonalContact>>(
  ContactsNotifier.new,
);
