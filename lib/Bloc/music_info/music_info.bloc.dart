import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relu_assignment/Bloc/music_info/music_info_event.dart';
import 'package:relu_assignment/Bloc/music_info/music_info_state.dart';
import 'package:relu_assignment/Core/connectivity_service.dart';
import 'package:relu_assignment/Repository/music_repo.dart';

class MusicInfoBloc extends Bloc<MusicInfoEvent, MusicInfoState> {
  final MusicRepository _repo;
  final ConnectivityService _connnectivityService;
  final int trackId;

  MusicInfoBloc(this._repo, this._connnectivityService, this.trackId)
      : super(MusicInfoLoadingState()) {
    _connnectivityService.connectivityStream.stream.listen((event) {
      if (event == ConnectivityResult.none) {
        add(MusicInfoNoInternetEvent());
      } else {
        add(LoadMusicInfoEvent());
      }
    });

    on<LoadMusicInfoEvent>((event, emit) async {
      emit(MusicInfoLoadingState());
      try {
        final model = await _repo.getMusicInfo(trackId);
        final lyricsModel = await _repo.getMusicLyrics(trackId);
        emit(MusicInfoLoadedState(model: model, musicLyricsModel: lyricsModel));
      } catch (e) {
        emit(MusicInfoErrorState(e.toString()));
      }
    });

    on<MusicInfoNoInternetEvent>((event, emit) {
      emit(MusicInfoNoInternetState());
    });
  }
}
