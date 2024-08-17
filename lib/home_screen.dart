import 'package:flutter/material.dart';
import 'package:music_player/screens/favourite_page/favourite_page.dart';
import 'package:music_player/screens/home_page/home_page.dart';
import 'package:music_player/screens/playlist_page/playlist_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:music_player/screens/music_page/music_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  List<SongModel> favorites = [];
  Map<String, List<SongModel>> playlists = {};
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? currentSongTitle;
  SongModel? currentSong;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      List<SongModel> songsList = await audioQuery.querySongs(
        sortType: SongSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );

      setState(() {
        songs = songsList;
      });
    } catch (e) {
      print("Error loading songs: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MusicPage(
        songs: songs,
        favorites: favorites,
        audioPlayer: audioPlayer,
        isPlaying: isPlaying,
        currentSongTitle: currentSongTitle,
        currentSong: currentSong,
        toggleFavorite: toggleFavorite,
        playMusic: playMusic,
        stopMusic: stopMusic,
      ),
      PlaylistPage(
        playlists: playlists.keys.toList(),
        addPlaylist: addPlaylist,
        addSongToPlaylist: addSongToPlaylist,
        deletePlaylist: deletePlaylist,
        songs: songs,
        audioPlayer: audioPlayer,
        playMusic: playMusic,
        stopMusic: stopMusic,
      ),
      HomePage(
        onItemTapped: _onItemTapped,
      ),
      FavoritesPage(
        favorites: favorites,
        toggleFavorite: toggleFavorite,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        backgroundColor: Colors.deepPurple,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.deepPurple,
        buttonBackgroundColor: Colors.amber,
        height: 60,
        items: <Widget>[
          Icon(Icons.music_note, size: 30, color: Colors.white),
          Icon(Icons.playlist_play, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void toggleFavorite(SongModel song) {
    setState(() {
      if (favorites.contains(song)) {
        favorites.remove(song);
      } else {
        favorites.add(song);
      }
    });
  }

  Future<void> playMusic(SongModel song) async {
    try {
      if (isPlaying) {
        await audioPlayer.stop();
        setState(() {
          isPlaying = false;
          currentSongTitle = null;
          currentSong = null;
        });
      }

      await audioPlayer.play(DeviceFileSource(song.data));
      setState(() {
        isPlaying = true;
        currentSongTitle = song.title;
        currentSong = song;
      });
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  Future<void> stopMusic() async {
    try {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
        currentSongTitle = null;
        currentSong = null;
      });
    } catch (e) {
      print("Error stopping music: $e");
    }
  }

  void addPlaylist(String playlistName) {
    setState(() {
      if (!playlists.containsKey(playlistName)) {
        playlists[playlistName] = [];
      }
    });
  }

  void addSongToPlaylist(String playlistName, SongModel song) {
    setState(() {
      if (playlists.containsKey(playlistName)) {
        if (!playlists[playlistName]!.contains(song)) {
          playlists[playlistName]!.add(song);
        }
      }
    });
  }

  void deletePlaylist(String playlistName) {
    setState(() {
      playlists.remove(playlistName);
    });
  }
}
