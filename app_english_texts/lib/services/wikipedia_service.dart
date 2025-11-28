import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class WikipediaService {
  static Future<String> fetchFirstParagraph(String url) async {
    try {
      // Extrair o título do artigo da URL
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      if (pathSegments.isEmpty || !pathSegments.contains('wiki')) {
        throw Exception('URL inválida da Wikipedia');
      }

      final titleIndex = pathSegments.indexOf('wiki') + 1;
      if (titleIndex >= pathSegments.length) {
        throw Exception('Título não encontrado na URL');
      }

      final title = pathSegments[titleIndex];

      // Usar a API REST da Wikipedia para buscar o HTML
      final apiUrl = Uri.parse(
        'https://en.wikipedia.org/api/rest_v1/page/html/$title',
      );

      final response = await http.get(apiUrl);

      if (response.statusCode != 200) {
        throw Exception(
          'Erro ${response.statusCode}: Falha ao carregar página',
        );
      }

      // Parse do HTML
      final document = parser.parse(response.body);

      // Buscar todos os parágrafos
      final paragraphs = document.querySelectorAll('p');

      // Encontrar o primeiro parágrafo com texto substancial
      for (var p in paragraphs) {
        final text = p.text.trim();
        // Ignorar parágrafos vazios ou muito curtos
        if (text.isNotEmpty && text.length > 50) {
          return text;
        }
      }

      throw Exception('Nenhum parágrafo encontrado');
    } catch (e) {
      throw Exception('Erro ao buscar texto da Wikipedia: $e');
    }
  }
}
