import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/track.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<Track>> fetchMisionesRemotas() async {
    try {
      final response = await _client
        .from('missions')
        .select();
      return (response as List).map((json) => Track.fromJson(json)).toList();
    } catch (e) {
      print("Error crítico en el canal de datos: $e");
      return [];
    }
  }
}