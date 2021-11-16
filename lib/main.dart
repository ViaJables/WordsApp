import 'dart:io';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/models/localuser.dart';
import 'package:synonym_app/ui/single_player/timercontroller.dart';
import 'package:synonym_app/ui/start_point/intro_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Admob.initialize();
  await Firebase.initializeApp();
  // appId: Platform.isAndroid
  //     ? 'ca-app-pub-3042907838603854~5345471733'
  //     : 'ca-app-pub-3042907838603854~2910880080');

  runApp(SynonymApp());
}

class SynonymApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));

    print("--------------------------------------------");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Timercontroller()),
        Provider(create: (_) => QuestionProvider()),
        Provider(create: (_) => LocalUser.empty()),
      ],
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ),
            primaryColor: Color.fromRGBO(239, 23, 115, 1),
            secondaryHeaderColor: Color.fromRGBO(0, 182, 232, 1),
            backgroundColor: Color.fromRGBO(37, 38, 65, 0.7),
          ),
          home: IntroScreen()),
    );
  }
}
