import 'package:flutter/material.dart';
import 'package:music_player/screens/favourite_page/favourite_page.dart';
import 'package:music_player/screens/playlist_page/playlist_page.dart';
import 'package:music_player/screens/music_page/music_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
      HomePage(onItemTapped: _onItemTapped),
      FavoritesPage(
        favorites: favorites,
        toggleFavorite: toggleFavorite,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.teal,
        buttonBackgroundColor: Colors.tealAccent.shade400,
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

class HomePage extends StatelessWidget {
  final Function(int) onItemTapped;

  HomePage({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 30.0), // Adjust the height to move the "HI" text down
            Text(
              'HI',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Dhoom Machalay With mp3',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'What you want to hear today?',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  _buildGridItem(
                    title: 'All Songs',
                    imagePath: 'assets/allsong.jpg',
                    onTap: () => onItemTapped(0),
                  ),
                  _buildGridItem(
                    title: 'Playlists',
                    imagePath: 'assets/playlist.png',
                    onTap: () => onItemTapped(1),
                  ),
                  _buildGridItem(
                    title: 'Favorites',
                    imagePath: 'assets/favourite.png',
                    onTap: () => onItemTapped(3),
                  ),
                  _buildGridItem(
                    title: 'Artists',
                    imagePath: 'assets/artist.png',
                    onTap: () => onItemTapped(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required String title,
    required String imagePath,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 6.0,
                      color: Colors.black.withOpacity(0.8),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
