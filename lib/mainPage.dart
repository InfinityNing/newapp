import 'package:flutter/material.dart';
import 'calc.dart';

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: new MainPageWidget(),
    );
  }
}

class MainPageWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MainPageWidgetState();
  }
}

class MainPageWidgetState extends State<MainPageWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Calc(),
      backgroundColor: Color(0xFFEAEAEA),
    );
  }
}
