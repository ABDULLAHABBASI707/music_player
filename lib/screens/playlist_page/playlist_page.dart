import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/music_page/musicplayer_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'New Playlist',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              addPlaylist(controller.text);
              controller.clear();
            }
          },
          child: Text('Create Playlist'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              String playlistName = playlists[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(playlistName),
                  leading: Icon(Icons.playlist_play, color: Colors.teal),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deletePlaylist(playlistName);
                    },
                  ),
                  onTap: () {
                    // Show a dialog to select a song to add
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add Song to $playlistName'),
                          content: Container(
                            width: double.maxFinite,
                            child: ListView.builder(
                              itemCount: songs.length,
                              itemBuilder: (context, songIndex) {
                                SongModel song = songs[songIndex];
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
                                  subtitle:
                                      Text(song.artist ?? 'Unknown Artist'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.add, color: Colors.teal),
                                    onPressed: () {
                                      // Add song to the first playlist in the list
                                      if (playlists.isNotEmpty) {
                                        addSongToPlaylist(
                                            playlists.first, song);
                                        playMusic(song);
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
