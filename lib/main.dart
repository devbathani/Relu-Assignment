import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:relu_assignment/Core/connectivity_service.dart';
import 'package:relu_assignment/Repository/music_repo.dart';
import 'package:relu_assignment/Ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(380, 720),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (_) => MusicRepository(),
            ),
            RepositoryProvider(
              create: (_) => ConnectivityService(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Assingnment',
            home: child,
          ),
        );
      },
      child: const HomePage(),
    );
  }
}
