import 'package:shared_preferences/shared_preferences.dart';

class UnderstoodWordsManager {
  static const _key = 'understood_words';

  static Future<Set<String>> getUnderstoodWords() async {
    final prefs = await SharedPreferences.getInstance();
    final words = prefs.getStringList(_key) ?? [];
    return words.toSet();
  }

  static Future<void> addUnderstoodWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final words = prefs.getStringList(_key) ?? [];
    final wordSet = words.toSet();
    wordSet.add(word.toLowerCase());
    await prefs.setStringList(_key, wordSet.toList());
  }

  static Future<void> removeUnderstoodWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final words = prefs.getStringList(_key) ?? [];
    final wordSet = words.toSet();
    wordSet.remove(word.toLowerCase());
    await prefs.setStringList(_key, wordSet.toList());
  }

  static Future<bool> isWordUnderstood(String word) async {
    final words = await getUnderstoodWords();
    return words.contains(word.toLowerCase());
  }
}
