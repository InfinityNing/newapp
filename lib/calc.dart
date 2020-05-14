import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dragButton.dart';
import 'calcButton.dart';
import 'historyList.dart';
import 'calcFunction.dart';
import 'codeLib.dart';
import 'historyPage.dart';

class Calc extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new CalcState();
  }
}
class CalcState extends State<Calc>{
  StringBuffer calcBuffer=new StringBuffer();
  bool justCal=false;
  String result='0',tempResult='';
  Color defaultResultColor=Color(0xCCFF0000),resultColor=Colors.black,
      buttonColor=Color(0xFFF5F5F5), clearButtonColor=Color(0xFFFF6347),
      resultButtonColor=Colors.blue;
  List calcHistory =new List();
//  List calcHistory =[
//    '1231321311321321','165231650312','1231','74365966','00002','102320','7413566',
//    '15612312','23','256262362','1415','95592306362','75126512651213','1651656','46511231313','51365465',
//    '56515156','2131','2020211111111111111','000001=2222','1651','65165=1161651','55555',
//    '15616','32135466464','321321','3213','32131','1231','1231','12312'
//  ];
  void change(String cc){
    setState(() {
      if(calcBuffer.toString()=='ERROR'){
        calcBuffer.clear();
        resetResult();
      }
      if(justCal==true&&cc!='+'&&cc!='-'&&cc!='×'&&cc!='÷'&&cc!='('&&cc!='.'&&cc!='%'){
        calcBuffer.clear();
        resetResult();
      }
      calcBuffer.write(cc);
      tempResult=calcBuffer.toString();
      realTimeCalc();
      justCal=false;
    });
  }
  void resetResult(){
    result='0';
  }
  void resetTempResult(){
    tempResult='';
  }
  void resetResultColor(){
    resultColor=Colors.black;
  }
  void realTimeCalc(){
    if(cal(tempResult)!='ERROR') {
      result=cal(tempResult);
      resultColor=defaultResultColor;
    }
  }
  void clear(){
    setState(() {
      calcBuffer.clear();
      resetResult();
      resetTempResult();
      resetResultColor();
    });
  }
  void del(){
    setState(() {
      if(calcBuffer.toString().length>1&&calcBuffer.toString()!='ERROR'){
        tempResult=calcBuffer.toString().substring(0,calcBuffer.toString().length-1);
        calcBuffer.clear();
        calcBuffer.write(tempResult);
        realTimeCalc();
        justCal=false;//如果刚刚完成计算，重置标记（不管标记处在什么状态），用于刚计算完删除一位结果后继续输入
      }
      else clear();
    });
  }
  void calculate(){
    if(easterEgg(tempResult)) return ;
    setState(() {
      if(tempResult=='') return ;
      tempResult=cal(tempResult);
      if(tempResult!='ERROR')
        addToHistory(calcBuffer.toString(), tempResult);
      calcBuffer.clear();
      calcBuffer.write(tempResult);
      resetResultColor();
      result=tempResult;
      resetTempResult();
      justCal=true;
    });
  }
  void addToHistory(String inputFormula,String inputResult){
    if(inputFormula!=inputResult)
      calcHistory.insert(0, inputFormula+'='+inputResult);
    else
      calcHistory.insert(0, inputResult);
  }
  void clickToCalc(int index){
    clear();
    change(calcHistory[index].toString().split('=')[0]);
  }
  void slideToDel(int index){
    calcHistory.removeAt(index);
  }
  void openNewPage(Widget newPage){
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context){
              return newPage;
            }
        )
      );
    });
  }
  bool easterEgg(String input){
    if(input=='333') {
      openNewPage(HistoryPage(calcHistory,clickToCalc,slideToDel));
      return true;
    }
    if(codeLib.contains(input)) {
      openNewPage(pageLib[codeLib.indexOf(input)]);
      return true;
    }
    else return false;
  }

  Widget _buildVerticalLayout(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height/2,
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'listTag',
                child: Material(//这里需要用material包围，否则返回来的时候dismissible组件会出错
                  color: Color(0xFFEAEAEA),
                  child: Container(//历史记录
                    height: MediaQuery.of(context).size.height/3,
                    child: HistoryWidget(calcHistory,MediaQuery.of(context).size.height/3,
                        MediaQuery.of(context).size.width,clickToCalc,slideToDel),
                  ),
                ),
              ),
              Container(//输入框
                height: MediaQuery.of(context).size.height/13,
                child:
                ListView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  children: <Widget>[
                    Text(tempResult,style: TextStyle(fontSize: 50),),
                  ],
                ),
              ),
              Container(//结果框
                height: MediaQuery.of(context).size.height/13,
                child:
                ListView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  children: <Widget>[
                    Text(result,style: TextStyle(fontSize: 50,color: resultColor),),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 0.0,indent: 10.0,endIndent: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CalcButtonWidget(clear,false,'C',clearButtonColor,Colors.white,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            DragButton(change,'( )',buttonColor,30,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(del,false,'➔',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'÷',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CalcButtonWidget(change,true,'7',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'8',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'9',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'×',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CalcButtonWidget(change,true,'4',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'5',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'6',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'-',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CalcButtonWidget(change,true,'1',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'2',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'3',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'+',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CalcButtonWidget(change,true,'%',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'.',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(change,true,'0',buttonColor,Colors.black,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
            CalcButtonWidget(calculate,false,'=',resultButtonColor,Colors.white,32,
                MediaQuery.of(context).size.height/12,MediaQuery.of(context).size.width/4.5),
          ],
        ),
      ],
    );
  }
  Widget _buildHorizontalLayout(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Hero(
              tag: 'listTag',
              child: Material(
                color: Color(0xFFEAEAEA),
                child: Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery.of(context).size.width/2,
                  child: HistoryWidget(calcHistory,MediaQuery.of(context).size.height/1.5,
                      MediaQuery.of(context).size.width/2,clickToCalc,slideToDel),
                ),
              ),
            ),
            Container(//输入框
              height: MediaQuery.of(context).size.height/6.1,
              width: MediaQuery.of(context).size.width/2,
              child:
              ListView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                children: <Widget>[
                  Text(tempResult,style: TextStyle(fontSize: 50),),
                ],
              ),
            ),
            Container(//结果框
              height: MediaQuery.of(context).size.height/6.1,
              width: MediaQuery.of(context).size.width/2,
              child:
              ListView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                children: <Widget>[
                  Text(result,style: TextStyle(fontSize: 50,color: resultColor),),
                ],
              ),
            ),
          ],
        ),
        VerticalDivider(width: 0.0,indent: 15.0,endIndent: 15.0),
        Container(
          width: MediaQuery.of(context).size.width/2,
          color: Color(0xFFEAEAEA),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CalcButtonWidget(clear,false,'C',clearButtonColor,Colors.white,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  DragButton(change,'( )',buttonColor,30,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(del,false,'➔',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'÷',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CalcButtonWidget(change,true,'7',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'8',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'9',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'×',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CalcButtonWidget(change,true,'4',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'5',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'6',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'-',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CalcButtonWidget(change,true,'1',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'2',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'3',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'+',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CalcButtonWidget(change,true,'%',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'.',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(change,true,'0',buttonColor,Colors.black,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                  CalcButtonWidget(calculate,false,'=',resultButtonColor,Colors.white,32,
                      MediaQuery.of(context).size.height/6.1,MediaQuery.of(context).size.width/9),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _buildVerticalLayout()
            : _buildHorizontalLayout();
      },
    );
  }
}
