import 'package:flutter/material.dart';

void main() {
  // MaterialApp is a class which groups other widget-like classes
  runApp(MaterialApp(
      // home parameter is the main page that'll open with the app
      // Scaffold implements basic visual layout structure
      home: Scaffold(
          // appBar is upper app bar containing it's title, etc.
          appBar: AppBar(
              // appBar's title
              title: const Text(
                'Elden Ringue',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.brown[700],
              centerTitle: true),
          // app's body (what's bellow the appBar)
          body: const Home())));
}

// Custom widget created extending the StatelessWidget class
// Stateless means it isn't capable of changing states (static)
class Home extends StatelessWidget {
  const Home({super.key});

  // The build method allows hot reload to this widget
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
      child: const Text('Olá! Bem vindo!', style: TextStyle(
        fontSize: 18,
      ),),
    );
  }
}
