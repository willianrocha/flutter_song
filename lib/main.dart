import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

void main() => runApp(new FlutterSong());

enum PlayerState { stopped, playing, paused }

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
  AudioPlayer audioPlayer = new AudioPlayer();
  PlayerState playerState = PlayerState.stopped;
  String kUrl = 'assets/audio2.mp3';
  String localFilePath;
  String currentAsset;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  Duration duration;
  Duration position;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged.listen(
            (p) => setState(() => position = p)
    );
    _audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future _loadAsset(aPlay) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = new File('${dir.path}/audio.mp3');

    ByteData asset = await rootBundle.load(aPlay);
    List<int> fBytes = new List(asset.lengthInBytes);
    for(var i=0; i < asset.lengthInBytes; i++) {
      try {
        fBytes[i] = asset.getInt8(i);
      } catch (e) {
        print(i);
        i = asset.lengthInBytes;
      }
    }
    await file.writeAsBytes(fBytes);
    if (await file.exists()) {
      debugPrint(file.path);
      setState(() {
        localFilePath = file.path;
      });
    }
    return localFilePath;
  }

  Future<void> play() async {
    var aPath = await _loadAsset(currentAsset);
    await audioPlayer.play(aPath);
    setState(() => playerState = PlayerState.playing);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hey Yeah")
        ),
      body: new Column(
        children: [
          new RaisedButton(
            elevation: 4.0,
            splashColor: Colors.blueGrey,
            onPressed: () {
              setState(() {
                currentAsset = "assets/hairy_song.mp3";
              });
              play();
            },
            child: new ConstrainedBox(
                constraints: new BoxConstraints(maxHeight: 300.0, maxWidth: 300.0),
                child: new Image(image: new AssetImage('assets/hairy_img.PNG'))
            ),
          ),
          new IconButton(
              onPressed: isPlaying || isPaused ? () => stop() : null,
              iconSize: 64.0,
              icon: new Icon(Icons.stop),
              color: Colors.cyan),
        ]
      ),
      ),
    );
  }

}
