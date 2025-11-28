import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word_definition.dart';

class DictionaryService {
  static const _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  static Future<WordDefinition> fetchWordDefinition(String word) async {
    final url = '$_baseUrl/${word.toLowerCase()}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 404) {
        throw Exception('Palavra não encontrada no dicionário');
      }

      if (response.statusCode != 200) {
        throw Exception(
          'Erro ${response.statusCode}: Falha ao carregar definição',
        );
      }

      final List<dynamic> data = jsonDecode(response.body);

      if (data.isEmpty) {
        throw Exception('Nenhuma definição encontrada');
      }

      return WordDefinition.fromJson(data.first as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erro ao buscar definição: $e');
    }
  }
}
