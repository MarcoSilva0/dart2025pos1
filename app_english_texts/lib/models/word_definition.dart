class WordDefinition {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;

  const WordDefinition({
    required this.word,
    this.phonetic,
    required this.phonetics,
    required this.meanings,
  });

  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'word': String word, 'meanings': List<dynamic> meanings} =>
        WordDefinition(
          word: word,
          phonetic: json['phonetic'] as String?,
          phonetics:
              (json['phonetics'] as List<dynamic>?)
                  ?.map((p) => Phonetic.fromJson(p as Map<String, dynamic>))
                  .toList() ??
              [],
          meanings: meanings
              .map((m) => Meaning.fromJson(m as Map<String, dynamic>))
              .toList(),
        ),
      _ => throw const FormatException('Failed to load word definition.'),
    };
  }

  String? get audioUrl {
    for (final phonetic in phonetics) {
      if (phonetic.audio != null && phonetic.audio!.isNotEmpty) {
        return phonetic.audio;
      }
    }
    return null;
  }
}

class Phonetic {
  final String? text;
  final String? audio;

  const Phonetic({this.text, this.audio});

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'] as String?,
      audio: json['audio'] as String?,
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  const Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'partOfSpeech': String partOfSpeech,
        'definitions': List<dynamic> definitions,
      } =>
        Meaning(
          partOfSpeech: partOfSpeech,
          definitions: definitions
              .map((d) => Definition.fromJson(d as Map<String, dynamic>))
              .toList(),
        ),
      _ => throw const FormatException('Failed to load meaning.'),
    };
  }
}

class Definition {
  final String definition;
  final String? example;

  const Definition({required this.definition, this.example});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'definition': String definition} => Definition(
        definition: definition,
        example: json['example'] as String?,
      ),
      _ => throw const FormatException('Failed to load definition.'),
    };
  }
}
