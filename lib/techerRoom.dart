

import 'dart:collection';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:highlight_text/highlight_text.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// ignore: import_of_legacy_library_into_null_safe
import 'package:speech_to_text/speech_to_text.dart' as stt;
// ignore: import_of_legacy_library_into_null_safe
import 'package:avatar_glow/avatar_glow.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late IO.Socket socket;
  @override
  void initState() {
    super.initState();
    connect();
    _speech = stt.SpeechToText();
  }

  void connect() {
    socket = IO.io('https://quiet-fortress-84492.herokuapp.com/',<String,dynamic> {
      "transports": ["websocket","polling"],
      "autoConnect":false,
    });
    socket.on('connect', (msg) => {
      print('Connected')
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
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: 
          TextHighlight(
            text: _text,
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print('output : $_text,$val');
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
           
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      socket.emit('chat message', _text);
      _speech.stop();
    }
  }
}
