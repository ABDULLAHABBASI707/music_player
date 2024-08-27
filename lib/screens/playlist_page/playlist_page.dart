import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/screens/music_page/musicplayer_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistPage extends StatefulWidget {
  final List<SongModel> songs;
  final AudioPlayer audioPlayer;
  final Function(SongModel) playMusic;
  final Function stopMusic;

  PlaylistPage({
    required this.songs,
    required this.audioPlayer,
    required this.playMusic,
    required this.stopMusic,
    required List<String> playlists,
    required void Function(String playlistName) addPlaylist,
    required void Function(String playlistName) deletePlaylist,
    required void Function(String playlistName, SongModel song)
        addSongToPlaylist,
  });

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Map<String, List<SongModel>> playlistSongs = {};
  TextEditingController controller = TextEditingController();
  List<SongModel> selectedSongs = [];
  List<String> playlists = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPlaylists = prefs.getStringList('playlists') ?? [];
    setState(() {
      playlists = storedPlaylists;
      for (var playlist in playlists) {
        final storedSongs = prefs.getStringList('playlist_$playlist') ?? [];
        playlistSongs[playlist] = storedSongs.map((id) {
          return widget.songs.firstWhere((song) => song.id.toString() == id);
        }).toList();
      }
    });
  }

  Future<void> _savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('playlists', playlists);
    for (var playlist in playlistSongs.keys) {
      final songIds =
          playlistSongs[playlist]!.map((song) => song.id.toString()).toList();
      await prefs.setStringList('playlist_$playlist', songIds);
    }
  }

  void _toggleSelection(SongModel song) {
    setState(() {
      if (selectedSongs.contains(song)) {
        selectedSongs.remove(song);
      } else {
        selectedSongs.add(song);
      }
    });
  }

  void _saveSelectedSongs(String playlistName) {
    for (var song in selectedSongs) {
      _addSongToPlaylist(playlistName, song);
    }
    selectedSongs.clear();
    Navigator.pop(context);
    _savePlaylists(); // Save playlists after modification
  }

  void _addSongToPlaylist(String playlistName, SongModel song) {
    setState(() {
      if (!playlistSongs[playlistName]!.contains(song)) {
        playlistSongs[playlistName]!.add(song);
      }
    });
    _savePlaylists(); // Save playlists after modification
  }

  void _showAddSongDialog(String playlistName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select song to add in playlist',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _saveSelectedSongs(playlistName);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: widget.songs.isNotEmpty
                        ? ListView.builder(
                            itemCount: widget.songs.length,
                            itemBuilder: (context, songIndex) {
                              SongModel song = widget.songs[songIndex];
                              bool isSelected = selectedSongs.contains(song);
                              return ListTile(
                                leading: QueryArtworkWidget(
                                  id: song.id,
                                  type: ArtworkType.AUDIO,
                                  artworkFit: BoxFit.cover,
                                  artworkBorder: BorderRadius.circular(40),
                                  artworkClipBehavior: Clip.antiAlias,
                                  nullArtworkWidget: CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    child: Icon(Icons.music_note,
                                        color: Colors.white),
                                  ),
                                ),
                                title: Text(song.title),
                                subtitle: Text(song.artist ?? 'Unknown Artist'),
                                trailing: Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: isSelected ? Colors.teal : Colors.grey,
                                ),
                                onTap: () {
                                  setState(() {
                                    _toggleSelection(song);
                                  });
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text('No songs available'),
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Playlist'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Playlist Name',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  String newPlaylistName = controller.text;
                  setState(() {
                    playlists.add(newPlaylistName);
                    playlistSongs[newPlaylistName] = [];
                  });
                  _savePlaylists(); // Save playlists after creation
                  controller.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Add Playlist'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  'Hi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "I'm creating a playlist",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Follow along and let's curate the ultimate soundtrack together",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Container(
            height: 180,
            width: 330,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage('assets/music_icon.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showCreatePlaylistDialog,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Create Playlist'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                String playlistName = playlists[index];
                List<SongModel> songsInPlaylist = playlistSongs[playlistName]!;
                return Card(
                  color: Colors.teal.shade300,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ExpansionTile(
                    title: Text(playlistName),
                    leading: Icon(Icons.playlist_play, color: Colors.white),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          playlists.remove(playlistName);
                          playlistSongs.remove(playlistName);
                        });
                        _savePlaylists(); // Save playlists after deletion
                      },
                    ),
                    children: songsInPlaylist.isNotEmpty
                        ? songsInPlaylist.map((song) {
                            return ListTile(
                              leading: QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(20),
                                artworkClipBehavior: Clip.antiAlias,
                                nullArtworkWidget: CircleAvatar(
                                  backgroundColor: Colors.teal,
                                  child: Icon(Icons.music_note,
                                      color: Colors.white),
                                ),
                              ),
                              title: Text(song.title),
                              subtitle: Text(song.artist ?? 'Unknown Artist'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MusicPlayerScreen(
                                        song: songsInPlaylist[index],
                                        songs: songsInPlaylist,
                                        audioPlayer: widget.audioPlayer,
                                        playMusic: widget.playMusic,
                                        stopMusic: widget.stopMusic,
                                      ),
                                    ));
                              },
                            );
                          }).toList()
                        : [
                            ListTile(
                              title: Text('No songs in this playlist'),
                            )
                          ],
                    onExpansionChanged: (isExpanded) {
                      if (isExpanded && songsInPlaylist.isEmpty) {
                        _showAddSongDialog(playlistName);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
