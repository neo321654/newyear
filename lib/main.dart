import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late VideoPlayerController _controller;


  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/Butterfly-209.mp4');
  }

  void addCommand() {
    setState(() {
      var res = addCommandToServer("qqqqqqq");
      _counter++;
    });
  }

  void getLastCommand() {
    setState(() {
      var res = getLastCommandFromServer();
      res.then((value) {
        print(value.body);
      });
    });
  }

  Future<http.Response> addCommandToServer(String title) {
    return http.post(
      //Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      Uri.parse('http://srv34889.ht-test.ru/index2.php'),
      body: {'name': 'doodle', 'text': 'blue'},
    );
  }

  Future<http.Response> getLastCommandFromServer() {
    return http.post(
      //Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      Uri.parse('http://srv34889.ht-test.ru/index3.php'),
      //body: {'name': 'doodle', 'text': 'blue'},
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _ButterFlyAssetVideo(_controller),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            MaterialButton(
                child: Text("GET last comand"),
                onPressed: () {
                  getLastCommand();
                }),
            MaterialButton(
                child: Text("start stop"),
                onPressed: () {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCommand,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class _ButterFlyAssetVideo extends StatefulWidget {
  _ButterFlyAssetVideo(VideoPlayerController this._controller);
  late VideoPlayerController _controller;

  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
     _controller = widget._controller;

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _ControlsOverlay(controller: _controller),
                 // VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  // static const _examplePlaybackRates = [
  //   0.25,
  //   0.5,
  //   1.0,
  //   1.5,
  //   2.0,
  //   3.0,
  //   5.0,
  //   10.0,
  // ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
        //   child: controller.value.isPlaying
        //       ? SizedBox.shrink()
        //       : Container(
        //           color: Colors.black26,
        //           child: Center(
        //             child: Icon(
        //               Icons.play_arrow,
        //               color: Colors.white,
        //               size: 100.0,
        //               semanticLabel: 'Play',
        //             ),
        //           ),
        //         ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: PopupMenuButton<double>(
        //     initialValue: controller.value.playbackSpeed,
        //     tooltip: 'Playback speed',
        //     onSelected: (speed) {
        //       controller.setPlaybackSpeed(speed);
        //     },
        //     itemBuilder: (context) {
        //       return [
        //         for (final speed in _examplePlaybackRates)
        //           PopupMenuItem(
        //             value: speed,
        //             child: Text('${speed}x'),
        //           )
        //       ];
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         // Using less vertical padding as the text is also longer
        //         // horizontally, so it feels like it would need more spacing
        //         // horizontally (matching the aspect ratio of the video).
        //         vertical: 12,
        //         horizontal: 16,
        //       ),
        //       child: Text('${controller.value.playbackSpeed}x'),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

