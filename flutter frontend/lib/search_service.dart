import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String _baseUrl = 'http://localhost:8080/search';

  Future<List<String>> search(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl?query=$query'));

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      return responseData.cast<String>().toList();
    } else {
      throw Exception('Failed to load links');
    }
  }
}
