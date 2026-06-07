import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/first_aid_guide.dart';

class FirstAidRepository {
  final _supabase = Supabase.instance.client;

  Future<List<FirstAidGuide>> getGuides() async {
    final response = await _supabase.from('first_aid_guides').select();

    return response
        .map<FirstAidGuide>((json) => FirstAidGuide.fromJson(json))
        .toList();
  }
}
