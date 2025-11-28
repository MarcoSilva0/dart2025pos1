import 'package:flutter/material.dart';
import '../services/understood_words_manager.dart';

class UnderstoodWordsPage extends StatefulWidget {
  const UnderstoodWordsPage({super.key});

  @override
  State<UnderstoodWordsPage> createState() => _UnderstoodWordsPageState();
}

class _UnderstoodWordsPageState extends State<UnderstoodWordsPage> {
  List<String> _understoodWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUnderstoodWords();
  }

  Future<void> _loadUnderstoodWords() async {
    setState(() {
      _isLoading = true;
    });

    final words = await UnderstoodWordsManager.getUnderstoodWords();
    final sortedWords = words.toList()..sort();

    setState(() {
      _understoodWords = sortedWords;
      _isLoading = false;
    });
  }

  Future<void> _removeWord(String word) async {
    await UnderstoodWordsManager.removeUnderstoodWord(word);
    _loadUnderstoodWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palavras Compreendidas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _understoodWords.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma palavra compreendida ainda',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Marque palavras como compreendidas ao estudar',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Text(
                        '${_understoodWords.length} palavra${_understoodWords.length != 1 ? 's' : ''} compreendida${_understoodWords.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: _understoodWords.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final word = _understoodWords[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text(
                            word[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          word,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.red.shade400,
                          tooltip: 'Remover da lista',
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Remover palavra'),
                                content: Text(
                                  'Deseja remover "$word" da lista de palavras compreendidas?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Remover'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              _removeWord(word);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
