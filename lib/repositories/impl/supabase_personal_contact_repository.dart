import '../../models/personal_contact.dart';
import '../../services/supabase_service.dart';
import '../personal_contact_repository.dart';

class SupabasePersonalContactRepository implements PersonalContactRepository {
  const SupabasePersonalContactRepository(this.service);

  final SupabaseService service;

  @override
  Future<List<PersonalContact>> getContacts() async {
    final data = await service.client
        .from('personal_contacts')
        .select()
        .order('name');
    return data
        .map<PersonalContact>((json) => PersonalContact.fromJson(json))
        .toList();
  }

  @override
  Future<PersonalContact> addContact(PersonalContact contact) async {
    final payload = <String, dynamic>{
      'name': contact.name,
      'phone': contact.phone,
      if (contact.relationship != null) 'relationship': contact.relationship,
    };
    final data = await service.client
        .from('personal_contacts')
        .insert(payload)
        .select()
        .single();
    return PersonalContact.fromJson(data);
  }

  @override
  Future<PersonalContact> updateContact(PersonalContact contact) async {
    final payload = <String, dynamic>{
      'name': contact.name,
      'phone': contact.phone,
      'relationship': contact.relationship,
    };
    final data = await service.client
        .from('personal_contacts')
        .update(payload)
        .eq('id', contact.id)
        .select()
        .single();
    return PersonalContact.fromJson(data);
  }

  @override
  Future<void> deleteContact(String id) async {
    await service.client.from('personal_contacts').delete().eq('id', id);
  }
}
