import 'package:flutter/material.dart';
import 'package:music_player/screens/music_page/musicplayer_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPage extends StatefulWidget {
  final List<SongModel> songs;
  final List<SongModel> favorites;
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final String? currentSongTitle;
  final SongModel? currentSong;
  final Function toggleFavorite;
  final Function playMusic;
  final Function stopMusic;

  MusicPage({
    required this.songs,
    required this.favorites,
    required this.audioPlayer,
    required this.isPlaying,
    required this.currentSongTitle,
    required this.currentSong,
    required this.toggleFavorite,
    required this.playMusic,
    required this.stopMusic,
  });

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with SingleTickerProviderStateMixin {
  List<SongModel> _filteredSongs = [];
  TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _filteredSongs = widget.songs;
    _searchController.addListener(_filterSongs);

    // Initialize the animation controller for the music note animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _loadFavorites();
  }

  void _filterSongs() {
    setState(() {
      _filteredSongs = widget.songs
          .where((song) => song.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _toggleFavorite(SongModel song) {
    widget.toggleFavorite(song);
    setState(() {});
    _saveFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteSongIds = prefs.getStringList('favoriteSongs') ?? [];

    setState(() {
      widget.favorites.clear();
      widget.favorites.addAll(widget.songs
          .where((song) => favoriteSongIds.contains(song.id.toString())));
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteSongIds =
        widget.favorites.map((song) => song.id.toString()).toList();
    await prefs.setStringList('favoriteSongs', favoriteSongIds);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal.shade200,
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Music',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none, // Removes the border
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.tealAccent.shade100, // Fill color
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                style: TextStyle(color: Colors.black), // Text color
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                // Keep the image aspect ratio square
                child: Image.asset(
                  'assets/music_theme.png',
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  height: 180,
                  width: 330, // Height can be adjusted as needed
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredSongs.length,
                itemBuilder: (context, index) {
                  final isCurrentSong =
                      widget.currentSong == _filteredSongs[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.green.shade100, width: 2),
                    ),
                    color: Colors
                        .tealAccent.shade100, // Background color for the song
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 6),
                      child: ListTile(
                        leading: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                  0,
                                  isCurrentSong
                                      ? -5 + 5 * _animationController.value
                                      : 0),
                              child: child,
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/music_theme.png'),
                          ),
                        ),
                        title: Text(
                          _filteredSongs[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                widget.favorites.contains(_filteredSongs[index])
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: widget.favorites
                                        .contains(_filteredSongs[index])
                                    ? Colors.red
                                    : null,
                              ),
                              onPressed: () {
                                _toggleFavorite(_filteredSongs[index]);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isCurrentSong && widget.isPlaying
                                    ? Icons.stop
                                    : Icons.play_arrow,
                              ),
                              onPressed: () {
                                if (isCurrentSong && widget.isPlaying) {
                                  widget.stopMusic();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MusicPlayerScreen(
                                        song: _filteredSongs[index],
                                        songs: widget.songs,
                                        audioPlayer: widget.audioPlayer,
                                        playMusic: widget.playMusic,
                                        stopMusic: widget.stopMusic,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
