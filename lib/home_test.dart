import 'package:flutter/material.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({super.key});

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  int weather = 20;

  void raiseWeather() {
    setState(() {
      weather = weather < 40 ? weather + 1 : 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold implements basic visual layout structure
    return Scaffold(
        // appBar is upper app bar containing it's title, etc.
        appBar: AppBar(
            // appBar's title
            title: const Text(
              'Climate Mobile',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blue[700],
            centerTitle: true),
        // app's body (what's bellow the appBar)
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Clima: $weatherºC'),
                const Expanded(child: SizedBox()),
                FilledButton(
                  onPressed: raiseWeather,
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white),
                  child: Text('+'),
                )
              ],
            ),
            Expanded(
              child: Image.asset(
                'assets/img/bg.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ));
  }
}
