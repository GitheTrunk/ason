import '../models/personal_contact.dart';

abstract class PersonalContactRepository {
  Future<List<PersonalContact>> getContacts();
  Future<PersonalContact> addContact(PersonalContact contact);
  Future<PersonalContact> updateContact(PersonalContact contact);
  Future<void> deleteContact(String id);
}
