import 'package:flutter/material.dart';
import '../services/understood_words_manager.dart';
import 'definition_page.dart';
import 'understood_words_page.dart';

class TextPage extends StatefulWidget {
  final String text;

  const TextPage({super.key, required this.text});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  Set<String> _understoodWords = {};

  @override
  void initState() {
    super.initState();
    _loadUnderstoodWords();
  }

  Future<void> _loadUnderstoodWords() async {
    final words = await UnderstoodWordsManager.getUnderstoodWords();
    setState(() {
      _understoodWords = words;
    });
  }

  List<String> _extractWords(String text) {
    // Remove pontuação e divide em palavras
    final cleanText = text.replaceAll(RegExp(r'[^\w\s]'), ' ');
    return cleanText.split(RegExp(r'\s+'));
  }

  bool _isWordUnderstood(String word) {
    return _understoodWords.contains(word.toLowerCase());
  }

  Future<void> _onWordTap(String word) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DefinitionPage(word: word)),
    );

    if (result == true) {
      _loadUnderstoodWords();
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = _extractWords(widget.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Palavras Compreendidas',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UnderstoodWordsPage(),
                ),
              );
              _loadUnderstoodWords();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: words.map((word) {
            if (word.trim().isEmpty) return const SizedBox.shrink();

            final isUnderstood = _isWordUnderstood(word);

            if (isUnderstood) {
              return Text('$word ', style: const TextStyle(fontSize: 16));
            }

            return InkWell(
              onTap: () => _onWordTap(word),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
