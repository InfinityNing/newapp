import 'package:flutter/material.dart';
import 'historyList.dart';

class HistoryPage extends StatefulWidget{
  List calcHistory=new List();
  Function clickToCalc,slideToDel;
  HistoryPage(this.calcHistory,this.clickToCalc,this.slideToDel);
  @override
  State<StatefulWidget> createState() {
    return HistoryPageState();
  }
}
class HistoryPageState extends State<HistoryPage>{
  void clickToReturn(){
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'listTag',
      child: Material(//这里需要用material或scaffold包围，否则dismissible组件会出错
        color: Color(0xFFEAEAEA),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: HistoryWidget(widget.calcHistory,MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width,widget.clickToCalc,widget.slideToDel,clickToReturn),
        ),
      ),
    );
  }
}
