import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/word_definition.dart';
import '../services/dictionary_service.dart';
import '../services/understood_words_manager.dart';

class DefinitionPage extends StatefulWidget {
  final String word;

  const DefinitionPage({super.key, required this.word});

  @override
  State<DefinitionPage> createState() => _DefinitionPageState();
}

class _DefinitionPageState extends State<DefinitionPage> {
  WordDefinition? _definition;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isUnderstood = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadDefinition();
    _checkIfUnderstood();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadDefinition() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final definition = await DictionaryService.fetchWordDefinition(
        widget.word,
      );
      setState(() {
        _definition = definition;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _checkIfUnderstood() async {
    final understood = await UnderstoodWordsManager.isWordUnderstood(
      widget.word,
    );
    setState(() {
      _isUnderstood = understood;
    });
  }

  Future<void> _toggleUnderstood() async {
    if (_isUnderstood) {
      await UnderstoodWordsManager.removeUnderstoodWord(widget.word);
    } else {
      await UnderstoodWordsManager.addUnderstoodWord(widget.word);
    }

    setState(() {
      _isUnderstood = !_isUnderstood;
    });
  }

  Future<void> _playAudio() async {
    if (_definition?.audioUrl == null) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        setState(() {
          _isPlaying = true;
        });

        await _audioPlayer.play(UrlSource(_definition!.audioUrl!));

        _audioPlayer.onPlayerComplete.listen((_) {
          setState(() {
            _isPlaying = false;
          });
        });
      }
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao reproduzir áudio: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isUnderstood ? Icons.check_circle : Icons.check_circle_outline,
              color: _isUnderstood ? Colors.green : null,
            ),
            tooltip: _isUnderstood
                ? 'Marcar como não compreendida'
                : 'Marcar como compreendida',
            onPressed: () async {
              await _toggleUnderstood();
              if (mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadDefinition,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            )
          : _definition == null
          ? const Center(child: Text('Nenhuma definição encontrada'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _definition!.word,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (_definition!.phonetic != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _definition!.phonetic!,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (_definition!.audioUrl != null)
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.stop_circle : Icons.volume_up,
                            size: 32,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: _playAudio,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  ..._definition!.meanings.map((meaning) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meaning.partOfSpeech,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          ...meaning.definitions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final definition = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${index + 1}. ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          definition.definition,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (definition.example != null) ...[
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                      ),
                                      child: Text(
                                        '"${definition.example}"',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
