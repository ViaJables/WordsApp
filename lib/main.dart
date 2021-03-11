import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:synonym_app/models/question.dart';
import 'package:synonym_app/models/user.dart';
import 'package:synonym_app/ui/single_player/timercontroller.dart';
import 'package:synonym_app/ui/start_point/splash.dart';
import 'package:synonym_app/ui/start_point/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(Platform.isAndroid
      ? 'ca-app-pub-3042907838603854~5345471733'
      : 'ca-app-pub-3042907838603854~2910880080');

  runApp(SynonymApp());
}

class SynonymApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("ppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppoo");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Timercontroller()),
        Provider(create: (_) => QuestionProvider()),
        Provider(create: (_) => User.empty()),
      ],
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Retro',
            primaryColor: Color(0xff6c8ec1),
            primaryColorDark: Color(0xffe64f62),
            accentColor: Color(0xff686767),
          ),
          home: IntroScreen()),
    );
  }
}
