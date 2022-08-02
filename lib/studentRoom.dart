
import 'dart:collection';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:highlight_text/highlight_text.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io('https://quiet-fortress-84492.herokuapp.com/',<String,dynamic> {
      "transports": ["websocket","polling"],
      "autoConnect":false,
    });
    socket.on('connect', (msg) => {
      print('Connected')
    });
    // _textMessage = "";
    socket.on('chat message', (msg) => {
      setState(() => {
         _textMessage += " $msg"

      })
    });
    socket.on('reconnect_attempt', (_) => print('Reconnecting'));
    socket.on('connecting', (_) => print('Connecting'));
    socket.on('disconnect', (_) => print('Disconnected'));
    socket.on('connect_error', (_) => print(_));
    socket.on('error', (_) => print(_));

    
    socket.connect();
  }

  final _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  
  String _textMessage = "Message:";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Room'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: 
          TextHighlight(
            text: _textMessage,
            words: _highlights as LinkedHashMap<String, HighlightedWord>,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}