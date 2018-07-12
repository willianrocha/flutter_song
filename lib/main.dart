import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:async';

void main() => runApp(new FlutterSong());

class FlutterSong extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new GloriousPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class GloriousPage extends StatefulWidget {
  GloriousPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SadGridState createState() => new _SadGridState();
}

class _SadGridState extends State<GloriousPage> {

  static play() async {
    final AudioPlayer _audioPlugin = new AudioPlayer();
    final _audio = 'assets/hairy_song.mp3';
    await _audioPlugin.play(_audio);
  }

  Widget songs = GridView.count(
    crossAxisCount: 2,
//    padding: const EdgeInsets.all(20.0),
//    crossAxisSpacing: 10.0,
    children: <Widget>[
      const Text("Ibagem legal 1"),
      const Text("Ibagem legal 2"),
      new RaisedButton(
        elevation: 4.0,
        splashColor: Colors.blueGrey,
        onPressed: play,
//        onPressed: () {
//          final AudioPlayer audioPlugin = new AudioPlayer();
////          // Play Song
//           audioPlugin.play('assets/hairy_song.mp3', isLocal: true);
//        },
        child: new ConstrainedBox(
            constraints: new BoxConstraints.expand(),
            child: new Image(image: new AssetImage('assets/hairy_img.PNG'))
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hey Yeah")
        ),
      body: songs,
      ),
    );
  }

}
