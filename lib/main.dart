import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:remindme/googleauth.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool load = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.teal),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "images/logo.png",
                      scale: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "Remind Me",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    )
                  ],
                )),
              ),
              Expanded(
                flex: 1,
                child: load
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Text(
                            "Create a To do and complete it...!",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white),
                          )
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          GoogleSignInButton(
                            onPressed: () async {
                              setState(() {
                                load = true;
                              });
                              FirebaseUser user =
                                  await AuthService().handleSignIn();
                              if (user.uid == loggedinUser.uid) {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/home');
                                setState(() {
                                  load = false;
                                });
                              } else {
                                setState(() {
                                  load = false;
                                });
                                print("Failed login");
                              }
                            },
                          ),
                        ],
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
