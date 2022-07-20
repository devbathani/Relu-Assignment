import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relu_assignment/Bloc/music/music_event.dart';
import 'package:relu_assignment/Bloc/music/music_state.dart';
import 'package:relu_assignment/Core/connectivity_service.dart';
import 'package:relu_assignment/Repository/music_repo.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final MusicRepository _repo;
  final ConnectivityService _connnectivityService;

  MusicBloc(this._repo, this._connnectivityService)
      : super(MusicLoadingState()) {
    _connnectivityService.connectivityStream.stream.listen((event) {
      if (event == ConnectivityResult.none) {
        add(NoInternetEvent());
      } else {
        add(LoadMusicEvent());
      }
    });
    
    on<LoadMusicEvent>((event, emit) async {
      emit(MusicLoadingState());
      try {
        final model = await _repo.getMusicList();
        emit(MusicLoadedState(model!));
      } catch (e) {
        emit(MusicErrorState(e.toString()));
      }
    });

    on<NoInternetEvent>((event, emit) {
      emit(NoInternetState());
    });
  }
}
