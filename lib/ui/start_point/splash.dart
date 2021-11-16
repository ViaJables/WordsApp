import 'package:flutter/material.dart';
import 'package:synonym_app/helpers/auth_helper.dart';
import 'package:synonym_app/ui/auth/login.dart';
import 'package:synonym_app/ui/start_point/home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
//  bool _animFlag;
//
  @override
  void initState() {
    super.initState();
//
//    _animFlag = false;

//    Future.delayed(Duration(seconds: 2)).then((val) {
//      setState(() {
//        _animFlag = true;
//      });
//
//      Future.delayed(Duration(milliseconds: 500)).then((val) {
//        Navigator.pushReplacement(
//          context,
//          PageRouteBuilder(
//            pageBuilder: (context, animation1, animation2) => Home(),
//          ),
//        );
//      });
//    });
//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/splash.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Align(
              alignment: Alignment(0, 0.8),
              child: MaterialButton(
                onPressed: () async {
                  var page;
                  if ((await AuthHelper().getCurrentUser(context)) == null)
                    page = Login();
                  else
                    page = Home();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => page),
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 10),
                minWidth: double.infinity,
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
