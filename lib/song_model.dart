import 'dart:convert';

// The SongModel class representing a song
class SongModel {
  final int id;
  final String title;
  final String data;
  final String? album;
  final String? artist;
  final int duration;

  SongModel({
    required this.id,
    required this.title,
    required this.data,
    this.album,
    this.artist,
    required this.duration,
  });

  // Convert a SongModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'data': data,
      'album': album ?? '',
      'artist': artist ?? '',
      'duration': duration,
    };
  }

  // Create a SongModel object from a JSON map
  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'],
      title: json['title'],
      data: json['data'],
      album: json['album'] != '' ? json['album'] : null,
      artist: json['artist'] != '' ? json['artist'] : null,
      duration: json['duration'],
    );
  }
}

// Utility functions for JSON conversion
Map<String, dynamic> songModelToJson(SongModel song) {
  return song.toJson();
}

SongModel songModelFromJson(Map<String, dynamic> json) {
  return SongModel.fromJson(json);
}
