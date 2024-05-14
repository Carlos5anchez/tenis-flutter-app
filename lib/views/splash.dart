import 'dart:async';
import 'dart:io';
import 'package:flutter_tenis/utils/biometrics.dart';
import 'package:flutter/material.dart';

///La primera vista de la app.
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _continue() async {
    // final bool isAuthenticated = await LocalAuthApi.authenticate();
    Navigator.of(context).pushNamed('menu');
    // if (isAuthenticated) {
    // } else {
    //   exit(0); //Si es false -> se sale de la app inmediatamente
    // }
  }

  @override
  void initState() {
    Timer(const Duration(milliseconds: 2400), () => _continue());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/app/doctor2.gif"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Image.asset(
            "assets/app/cmr_logo.png",
            height: 45,
          ),
        ),
      ),
    );
  }
}
