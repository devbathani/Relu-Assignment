import 'package:relu_assignment/Model/music_info_model.dart';
import 'package:relu_assignment/Model/music_lyrics.dart';

abstract class MusicInfoState {}

class MusicInfoLoadingState extends MusicInfoState {}

class MusicLyricsLoadingState extends MusicInfoState {}

class MusicInfoErrorState extends MusicInfoState {
  final String message;
  MusicInfoErrorState(this.message);
}

class MusicInfoLoadedState extends MusicInfoState {
  final MusicInfoModel model;
  final MusicLyricsModel musicLyricsModel;
  MusicInfoLoadedState({required this.model, required this.musicLyricsModel});
}

class MusicInfoNoInternetState extends MusicInfoState {}
