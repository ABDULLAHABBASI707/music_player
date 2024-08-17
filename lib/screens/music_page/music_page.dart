import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/screens/music_page/musicplayer_screen.dart';

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

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Music',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none, // Removes the border
              ),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.tealAccent.shade400, // Fill color
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            ),
            style: TextStyle(color: Colors.white), // Text color
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Full-screen background image
              Positioned.fill(
                child: Image.asset(
                  'assets/music_theme.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // ListView for music list
              ListView.builder(
                itemCount: _filteredSongs.length,
                itemBuilder: (context, index) {
                  final isCurrentSong =
                      widget.currentSong == _filteredSongs[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side:
                          BorderSide(color: Colors.tealAccent.shade400, width: 2),
                    ),
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
                        child: QueryArtworkWidget(
                          id: _filteredSongs[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          artworkFit: BoxFit.cover,
                          artworkBorder: BorderRadius.circular(30.0),
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
                              color: widget.favorites.contains(_filteredSongs[index])
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () =>
                                widget.toggleFavorite(_filteredSongs[index]),
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
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
