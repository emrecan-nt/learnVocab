import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;


class VocabularyScreen extends StatefulWidget {
  final String level;
  VocabularyScreen({required this.level});

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  Map<String, String> words = {};
  final Map<String, bool> _showTranslations = {};
  final Map<String, bool> _knownWords = {};
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _loadWords();
    _loadKnownWords();
  }

  Future<void> _loadWords() async {
    final String fileName = 'assets/${widget.level}.txt';
    final String response = await rootBundle.loadString(fileName);
    final List<String> lines = response.split('\n');
    final Map<String, String> tempWords = {};
    for (String line in lines) {
      final List<String> parts = line.split('=');
      if (parts.length == 2) {
        tempWords[parts[0].trim()] = parts[1].trim();
      }
    }
    setState(() {
      words = tempWords;
      _showTranslations.addAll(
          Map.fromIterable(words.keys, key: (k) => k, value: (v) => false));
    });
  }

  Future<void> _loadKnownWords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? knownWordsList =
        prefs.getStringList('${widget.level}_known_words');
    if (knownWordsList != null) {
      setState(() {
        for (String word in knownWordsList) {
          _knownWords[word] = true;
        }
      });
    }
  }

  Future<void> _saveKnownWords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> knownWordsList = _knownWords.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    await prefs.setStringList('${widget.level}_known_words', knownWordsList);
  }

  void _toggleTranslation(String word) {
    setState(() {
      _showTranslations[word] = !(_showTranslations[word] ?? false);
    });
  }

  void _toggleKnown(String word) {
    setState(() {
      _knownWords[word] = !(_knownWords[word] ?? false);
    });
    _saveKnownWords();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.speak(text);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level}'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: words.entries.map((entry) {
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    _showTranslations[entry.key] == true
                        ? entry.value
                        : entry.key,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showTranslations[entry.key] == true
                        ? Icons.translate
                        : Icons.translate,
                  ),
                  onPressed: () {
                    _toggleTranslation(entry.key);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () {
                    _speak(entry.key);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    color: _knownWords[entry.key] == true
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onPressed: () {
                    _toggleKnown(entry.key);
                  },
                ),
              ],
            ),
            onTap: () {
              _toggleTranslation(entry.key);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _saveKnownWords();
    flutterTts.stop();
    super.dispose();
  }
}
