import 'package:flutter/material.dart';
import 'package:gps_and_google_maps/home_screen.dart';

void main(){
  runApp(const MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:HomeScreen.routeName ,
      routes: {
        HomeScreen.routeName:(_)=> HomeScreen(),
      },
    );
  }
}
