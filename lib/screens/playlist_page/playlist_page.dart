import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistPage extends StatefulWidget {
  final List<String> playlists;
  final Function(String) addPlaylist;
  final Function(String, SongModel) addSongToPlaylist;
  final Function(String) deletePlaylist;
  final List<SongModel> songs;
  final AudioPlayer audioPlayer;
  final Function(SongModel) playMusic;
  final Function stopMusic;

  PlaylistPage({
    required this.playlists,
    required this.addPlaylist,
    required this.addSongToPlaylist,
    required this.deletePlaylist,
    required this.songs,
    required this.audioPlayer,
    required this.playMusic,
    required this.stopMusic,
  });

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Map<String, List<SongModel>> playlistSongs = {};
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var playlist in widget.playlists) {
      playlistSongs[playlist] = [];
    }
  }

  void _addSongToPlaylist(String playlistName, SongModel song) {
    setState(() {
      if (!playlistSongs[playlistName]!.contains(song)) {
        playlistSongs[playlistName]!.add(song);
        // Call the function provided to add the song to the playlist
        widget.addSongToPlaylist(playlistName, song);
      }
    });
  }

  void _showAddSongDialog(String playlistName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Song to $playlistName'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: widget.songs.length,
              itemBuilder: (context, songIndex) {
                SongModel song = widget.songs[songIndex];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    artworkBorder: BorderRadius.circular(40),
                    artworkClipBehavior: Clip.antiAlias,
                    nullArtworkWidget: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.music_note, color: Colors.white),
                    ),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.artist ?? 'Unknown Artist'),
                  trailing: IconButton(
                    icon: Icon(Icons.add, color: Colors.teal),
                    onPressed: () {
                      _addSongToPlaylist(playlistName, song);
                      Navigator.pop(context); // Close the dialog after adding
                    },
                  ),
                );
              },
            ),
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
                  widget.addPlaylist(newPlaylistName);
                  setState(() {
                    playlistSongs[newPlaylistName] = [];
                  });
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
      backgroundColor: Colors.teal.shade100,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 70),
          // Text section
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
          // Image with circular border radius
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
          // Button to create a new playlist
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _showCreatePlaylistDialog,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal, // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Add Playlist'),
            ),
          ),
          // Display playlists
          Expanded(
            child: ListView.builder(
              itemCount: widget.playlists.length,
              itemBuilder: (context, index) {
                String playlistName = widget.playlists[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(playlistName),
                    leading: Icon(Icons.playlist_play, color: Colors.teal),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.deletePlaylist(playlistName);
                        setState(() {
                          playlistSongs.remove(playlistName);
                        });
                      },
                    ),
                    onTap: () {
                      _showAddSongDialog(
                          playlistName); // Show the dialog to add songs when the playlist is tapped
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
