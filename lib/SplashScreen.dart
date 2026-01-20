import 'dart:async';
import 'package:firstapp/Home.dart';
import 'package:flutter/material.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State createState() => _SplashscreenState();
}

class _SplashscreenState extends State{
  @override
  void initState(){
    Timer(Duration(seconds:3),()=>Navigator.of(context,)
        .push(MaterialPageRoute(builder: (context)=>Home(),
    )));
    // super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: CircleAvatar(backgroundImage:AssetImage("assets/imges/a.png"),),
      ),
    );
  }
}
