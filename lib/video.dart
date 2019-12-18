import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  State<VideoPage> createState() => VideoPageState();
}

class VideoPageState extends State<VideoPage> {
  VideoPlayerController _controller;
  final progress = _PlayProgress();
  _PlayStatus status = _PlayStatus();
  _Initial _initial = _Initial();
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _initial.updateStatus(true);
      });
    _controller.addListener(() {
      print(_controller.value.toString());
      progress.updatePosition(_controller.value.position,
          _controller.value.buffered, _controller.value.duration);
      if (_controller.value.hasError) {
        status.updateStatus(PlayStatus.ERROR);
        var msg = _controller.value.errorDescription;
        print("ErrorMsg: $msg");
      }
      if (_controller.value.initialized) {
        if (_controller.value.isPlaying) {
          status.updateStatus(PlayStatus.PLAYING);
        } else {
          status.updateStatus(PlayStatus.PAUSED);
        }
        if (_controller.value.position.inSeconds ==
            _controller.value.duration.inSeconds) {
          status.updateStatus(PlayStatus.COMPLETED);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
          child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: progress),
          ChangeNotifierProvider.value(value: status),
          ChangeNotifierProvider.value(value: _initial),
        ],
        child: _PlayView(_controller),
      )),
    );
  }
}

class _PlayView extends StatelessWidget {
  final VideoPlayerController _controller;

  _PlayView(this._controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Consumer<_Initial>(
          builder: (context, value, child) {
            return value.initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator();
          },
        ),
        Consumer<_PlayStatus>(
          builder: (context, value, child) {
            return IconButton(
              icon: Icon(value._status == PlayStatus.PLAYING
                  ? Icons.pause
                  : Icons.play_arrow),
              onPressed:()=> playOrPause(value),
            );
          },
        ),
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
        ),
        Consumer<_PlayProgress>(
          builder: (context, value, child) {
            return Text(
                "${_printDuration(value._position)}/${_printDuration(value._total)}");
          },
        ),
      ],
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> playOrPause(_PlayStatus st) async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    } else {
      if(st._status == PlayStatus.COMPLETED){
        await _controller.seekTo(Duration());
      }
      await _controller.play();
    }
  }
}

class _PlayStatus with ChangeNotifier {
  PlayStatus _status = PlayStatus.PREPEARED;

  void updateStatus(PlayStatus st) {
    if (st == this._status) {
      return;
    }
    print("updateStatus $st");
    this._status = st;
    notifyListeners();
  }
}

class _Initial with ChangeNotifier {
  bool initialized = false;

  void updateStatus(bool st) {
    if (initialized == st) {
      return;
    }
    print("initial $st");
    initialized = st;
    notifyListeners();
  }
}

enum PlayStatus {
  PREPEARED,
  PLAYING,
  PAUSED,
  COMPLETED,
  ERROR,
}

class _PlayProgress with ChangeNotifier {
  Duration _position = Duration();
  List<DurationRange> _bufferd = List<DurationRange>();
  Duration _total = Duration();

  void updatePosition(
      Duration position, List<DurationRange> bufferd, Duration total) {
    if (position == _position && bufferd == _bufferd && total == total) {
      return;
    }
    _position = position;
    _bufferd = bufferd;
    _total = total;
    notifyListeners();
  }
}
