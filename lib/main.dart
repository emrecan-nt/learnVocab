import 'package:flutter/material.dart';
import 'vocabulary_screen.dart';
import 'seviye_status_screen.dart.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Vocabulary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ENGLISH VOCABULARY'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: <Widget>[
          _buildCard(context, 'A1', const Color.fromARGB(255, 185, 238, 101), Colors.blue),
          _buildCard(context, 'A2', const Color.fromARGB(255, 185, 238, 101), Colors.blue),
          _buildCard(context, 'B1', const Color.fromARGB(255, 185, 238, 101), Colors.blue),
          _buildCard(context, 'B2', const Color.fromARGB(255, 185, 238, 101), Colors.blue),
          _buildCard(context, 'C1', const Color.fromARGB(255, 185, 238, 101), Colors.blue),
          
        
          Card(
            color: const Color.fromARGB(255, 185, 238, 101),
            elevation: 5,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(20), 
              title: Text(
                'Your Level',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelStatusScreen()),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Developed by Emre Mızrak © 2024',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String level, Color color, Color shadowColor) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        color: color, 
        shadowColor: shadowColor, 
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 80, 
          child: ListTile(
            contentPadding: EdgeInsets.all(20), 
            title: Text(
              level,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue, 
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VocabularyScreen(level: level),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
