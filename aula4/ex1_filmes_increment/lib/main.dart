import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Album {
  int userId;
  int id;
  String title;

  Album({required this.userId, required this.id, required this.title});
}

Future<Album> fetchAlbum(int id) async {
  // Simulate network delay
  var response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
  );
  var resultado = jsonDecode(response.body);
  return Album(
    userId: resultado['userId'],
    id: resultado['id'],
    title: resultado['title'],
  );
}

class _MyHomePageState extends State<MyHomePage> {
  late Album album = Album(userId: 0, id: 0, title: '');
  int albumId = 1;
  bool loadingAlbum = true;

  @override
  void initState() {
    super.initState();
    fetchAlbum(albumId).then((value) {
      setState(() {
        album = value;
        loadingAlbum = false;
      });
    });
  }

  void _goToPreviousAlbum() {
    if (albumId <= 1) return;

    setState(() {
      loadingAlbum = true;
    });

    fetchAlbum(--albumId).then((value) {
      setState(() {
        album = value;
        loadingAlbum = false;
      });
    });
  }

  void _goToNextAlbum() {
    setState(() {
      loadingAlbum = true;
    });

    fetchAlbum(++albumId).then((value) {
      setState(() {
        album = value;
        loadingAlbum = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(loadingAlbum ? 'Loading...' : album.title),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (loadingAlbum || albumId <= 1)
                      ? null
                      : _goToPreviousAlbum,
                  child: const Text('<'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: loadingAlbum ? null : _goToNextAlbum,
                  child: const Text('>'),
                ),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
