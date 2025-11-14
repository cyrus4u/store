import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl =
      'https://ukrshwdqetdpzfsjmgbc.supabase.co/rest/v1/';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrcnNod2RxZXRkcHpmc2ptZ2JjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4NDkzMzMsImV4cCI6MjA3ODQyNTMzM30.KNnALmGW6pW5GrUslwnL07dNUQRDwbYkzIhJV2bi4XU';

  final Dio _dio = Dio();

  Future<List<T>> fetchData<T>(
    String tableName,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _dio.get(
        '$baseUrl$tableName?order=id.asc',
        options: Options(
          headers: {
            'apikey': apiKey,
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((item) => fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('❌ Fetch error ($tableName): $e');
      return [];
    }
  }
}
