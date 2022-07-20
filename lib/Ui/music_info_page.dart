import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:relu_assignment/Bloc/music_info/music_info.bloc.dart';
import 'package:relu_assignment/Bloc/music_info/music_info_event.dart';
import 'package:relu_assignment/Bloc/music_info/music_info_state.dart';
import 'package:relu_assignment/Core/connectivity_service.dart';
import 'package:relu_assignment/Repository/music_repo.dart';
import 'package:relu_assignment/Ui/widgets/loading_widget.dart';
import 'package:relu_assignment/Ui/widgets/music_info.dart';

class MusicInfoPage extends StatelessWidget {
  const MusicInfoPage({Key? key, required this.trackId}) : super(key: key);
  final int trackId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MusicInfoBloc>(
      create: (context) => MusicInfoBloc(
          RepositoryProvider.of<MusicRepository>(context),
          RepositoryProvider.of<ConnectivityService>(context),
          trackId)
        ..add(LoadMusicInfoEvent()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Music Info",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<MusicInfoBloc, MusicInfoState>(
                  builder: (context, state) {
                    log("Music Info State : $state");
                    if (state is MusicInfoNoInternetState) {
                      return Center(
                        child: Text(
                          "No Internet :)",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    if (state is MusicInfoErrorState) {
                      return LoadingWidget(message: state.message);
                    }
                    if (state is MusicInfoLoadedState) {
                      final musicInfo = state.model.message!.body.track;
                      final lyricsInfo =
                          state.musicLyricsModel.message!.body.lyrics;
                      return Column(
                        children: [
                          MusicInfo(
                            albumName: musicInfo.albumName,
                            artistName: musicInfo.artistName,
                            trackName: musicInfo.trackName,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                lyricsInfo.lyricsBody,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    if (state is MusicInfoLoadingState) {
                      return const CircularProgressIndicator();
                    }

                    return const LoadingWidget(
                        message: 'SomeThing went wrong !!!');
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
