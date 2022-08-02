import 'package:flutter/material.dart';
import 'studentRoom.dart';
import 'techerRoom.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: 
      Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded( // Place `Expanded` inside `Row`
                  child: ElevatedButton(
                    child: Text('Student'),
                    onPressed: () {
                     Navigator.push(
                         context,
                          MaterialPageRoute(builder: (context) =>  SecondRoute()));
                    }, // Every button need a callback
                  ),
                ),
                Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                  child: ElevatedButton(
                    child: Text('Techer'),
                    onPressed: () { Navigator.push(
                         context,
                          MaterialPageRoute(builder: (context) => SpeechScreen()));
                        },
                  ),
                ),
              ],
      )
    );
  }
}