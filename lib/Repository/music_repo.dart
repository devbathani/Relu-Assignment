import 'dart:developer';

import 'package:relu_assignment/Core/logger.dart';

import 'package:http/http.dart' as http;
import 'package:relu_assignment/Model/music_info_model.dart';
import 'package:relu_assignment/Model/music_lyrics.dart';
import 'package:relu_assignment/Model/music_model.dart';

class MusicRepository {
  final _base_url = "https://api.musixmatch.com";
  final _api_key = "9f6249aabc4f246d0bda475845ecc77f";

  ///This function will return the list of music from the given API
  Future<MusicModel?> getMusicList() async {
    MusicModel? musicList;
    Uri url = Uri.parse("$_base_url/ws/1.1/chart.tracks.get?apikey=$_api_key");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      musicList = musicModelFromJson(response.body);
      for (var element in musicList.message.body.trackList) {
        log(element.track.trackName);
      }
    } else {
      logger.e("Error fetching data");
    }
    return musicList;
  }

  ///This function will return the Information of music from the given API
  Future<MusicInfoModel> getMusicInfo(int trackId) async {
    MusicInfoModel musicList = MusicInfoModel();
    Uri url = Uri.parse(
        "$_base_url/ws/1.1/track.get?track_id=$trackId&apikey=$_api_key");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      musicList = musicInfoModelFromJson(response.body);
      log(musicList.message!.body.track.albumName);
    } else {
      logger.e("Error fetching data");
    }
    return musicList;
  }

  ///This function will return the Lyrics of music from the given API
  Future<MusicLyricsModel> getMusicLyrics(int trackId) async {
    MusicLyricsModel musicList = MusicLyricsModel();
    Uri url = Uri.parse(
        "$_base_url/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=$_api_key");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      musicList = musicLyricsModelFromJson(response.body);
      log(musicList.message!.body.lyrics.lyricsBody);
    } else {
      logger.e("Error fetching data");
    }
    return musicList;
  }
}
