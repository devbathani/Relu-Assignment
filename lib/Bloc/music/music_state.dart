import 'package:relu_assignment/Model/music_model.dart';

abstract class MusicState {}

class MusicLoadingState extends MusicState {}

class MusicErrorState extends MusicState {
  final String message;
  MusicErrorState(this.message);
}

class MusicLoadedState extends MusicState {
  final MusicModel model;
  MusicLoadedState(this.model);
}

class NoInternetState extends MusicState {}
