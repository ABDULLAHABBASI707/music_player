import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:marquee/marquee.dart';

class MusicPlayerScreen extends StatefulWidget {
  final SongModel song;
  final List<SongModel> songs;
  final AudioPlayer audioPlayer;
  final Function playMusic;
  final Function stopMusic;

  MusicPlayerScreen({
    required this.song,
    required this.songs,
    required this.audioPlayer,
    required this.playMusic,
    required this.stopMusic,
  });

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late int currentIndex;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.songs.indexOf(widget.song);
    widget.playMusic(widget.songs[currentIndex]);

    widget.audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    widget.audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    widget.audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  void playNext() {
    if (currentIndex < widget.songs.length - 1) {
      currentIndex++;
      widget.playMusic(widget.songs[currentIndex]);
      setState(() {
        isPlaying = true;
      });
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
      widget.playMusic(widget.songs[currentIndex]);
      setState(() {
        isPlaying = true;
      });
    }
  }

  void seekToPosition(double seconds) {
    widget.audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        widget.audioPlayer.pause();
      } else {
        widget.audioPlayer.resume();
      }
      isPlaying = !isPlaying;
    });
  }

  void _stopMusic() {
    widget.audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.speed, color: Colors.black),
                title: Text('Set Speed', style: TextStyle(color: Colors.black)),
                onTap: () {
                  _showSpeedDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.timer, color: Colors.black),
                title: Text('Set Sleep Timer',
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  _showSleepTimerDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal.shade800,
          title:
              Text('Set Playback Speed', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSpeedOption('0.5x', 0.5),
              _buildSpeedOption('1.0x (Normal)', 1.0),
              _buildSpeedOption('1.5x', 1.5),
              _buildSpeedOption('2.0x', 2.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeedOption(String label, double speed) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: () {
        widget.audioPlayer.setPlaybackRate(speed);
        Navigator.pop(context);
      },
    );
  }

  void _showSleepTimerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal.shade800,
          title: Text('Set Sleep Timer', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSleepTimerOption('5 Minutes', Duration(minutes: 5)),
              _buildSleepTimerOption('15 Minutes', Duration(minutes: 15)),
              _buildSleepTimerOption('30 Minutes', Duration(minutes: 30)),
              _buildSleepTimerOption('1 Hour', Duration(hours: 1)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSleepTimerOption(String label, Duration duration) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: () {
        _setSleepTimer(duration);
        Navigator.pop(context);
      },
    );
  }

  void _setSleepTimer(Duration duration) {
    Future.delayed(duration, () {
      widget.audioPlayer.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Now Playing',
                style: TextStyle(
                  wordSpacing: 2,
                  letterSpacing: 3,
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoSlab',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: Marquee(
                  text: widget.songs[currentIndex].title,
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'RobotoSlab',
                  ),
                  blankSpace: 100.0,
                  velocity: 30.0,
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  'assets/allsong.jpg',
                  height: 180,
                  width: 330,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.songs[currentIndex].artist ?? 'Unknown Artist',
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _currentPosition.inSeconds.toDouble(),
                      min: 0.0,
                      max: _totalDuration.inSeconds.toDouble(),
                      onChanged: (value) {
                        seekToPosition(value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: _showSettingsDialog,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      _formatDuration(_totalDuration),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        size: 40, color: Colors.white),
                    onPressed: playPrevious,
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, size: 40, color: Colors.white),
                    onPressed: playNext,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
