import 'package:flutter/material.dart';
import 'calcButton.dart';

class TempPage extends StatefulWidget{
  List versionInfo=['Beta 200514.1','Designed By InfinityNing','All Rights Reserved'];
  @override
  State<StatefulWidget> createState() {
    return TempPageState();
  }
}
class TempPageState extends State<TempPage>{
  void func(){
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(),
          CalcButtonWidget(func,false,'NMSL',Colors.blue,Colors.white,40,200,200,),
          Column(
            children: <Widget>[
              Text(widget.versionInfo[0],
                style: TextStyle(color: Colors.grey,fontSize: 13),),
              Text(widget.versionInfo[1],
                style: TextStyle(color: Colors.grey,fontSize: 13),),
              Text(widget.versionInfo[2],
                style: TextStyle(color: Colors.grey,fontSize: 13),),
            ],
          ),
        ],
      ),
    );
  }
}