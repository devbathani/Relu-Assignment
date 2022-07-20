import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:relu_assignment/Bloc/music/music_bloc.dart';
import 'package:relu_assignment/Bloc/music/music_event.dart';
import 'package:relu_assignment/Bloc/music/music_state.dart';
import 'package:relu_assignment/Core/connectivity_service.dart';
import 'package:relu_assignment/Repository/music_repo.dart';
import 'package:relu_assignment/Ui/music_info_page.dart';
import 'package:relu_assignment/Ui/widgets/loading_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MusicBloc>(
      create: (context) => MusicBloc(
          RepositoryProvider.of<MusicRepository>(context),
          RepositoryProvider.of<ConnectivityService>(context))
        ..add(LoadMusicEvent()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Relu Assignment",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<MusicBloc, MusicState>(
                  builder: (context, state) {
                    if (state is NoInternetState) {
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
                    if (state is MusicErrorState) {
                      return LoadingWidget(message: state.message);
                    } else if (state is MusicLoadedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                            state.model.message.body.trackList.length, (index) {
                          final musicInfo =
                              state.model.message.body.trackList[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MusicInfoPage(
                                        trackId: musicInfo.track.trackId),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
                                  child: Column(
                                    children: [
                                      Text(
                                        musicInfo.track.albumName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15.sp),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        musicInfo.track.artistName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
