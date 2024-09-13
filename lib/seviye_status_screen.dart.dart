import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LevelStatusScreen extends StatefulWidget {
  @override
  _LevelStatusScreenState createState() => _LevelStatusScreenState();
}

class _LevelStatusScreenState extends State<LevelStatusScreen> {
  final Map<String, int> levels = {
    'A1': 895,
    'A2': 864,
    'B1': 802,
    'B2': 1432,
    'C1': 1313,
  };

  Map<String, int> knownWords = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKnownWords();
  }

  Future<void> _loadKnownWords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, int> tempKnownWords = {};

    for (String level in levels.keys) {
      final List<String>? knownWordsList = prefs.getStringList('${level}_known_words');
      tempKnownWords[level] = knownWordsList?.length ?? 0;
    }

    setState(() {
      knownWords = tempKnownWords;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Level'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: levels.keys.map((level) {
                int totalWords = levels[level]!;
                int knownCount = knownWords[level] ?? 0;
                double percentage = (knownCount / totalWords);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Stack(
                          children: [
                            Center(
                              child: CircularProgressIndicator(
                                value: percentage,
                                strokeWidth: 6,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${(percentage * 100).toStringAsFixed(1)}%',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                     
                      tileColor: const Color.fromARGB(255, 185, 238, 101), 
                      title: Text(
                        '$level',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, 
                        ),
                      ),
                      subtitle: Text(
                        'Known: $knownCount / Total: $totalWords',
                        style: TextStyle(color: Colors.blue), 
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
             bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Developed by Emre Mızrak  © 2024',
          style: TextStyle(fontSize: 12, color: Colors.grey), 
          textAlign: TextAlign.center, 
        ),
      ),
    );
  }
}
