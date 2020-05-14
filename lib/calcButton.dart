import 'package:flutter/material.dart';

class CalcButtonWidget extends StatefulWidget{
  Function func;
  bool ifContent=false;//返回函数是否传参
  Color buttonColor=Colors.black,textColor=Colors.black;
  String buttonText;
  double buttonFontSize,buttonHeight,buttonWidth;
  CalcButtonWidget(this.func,this.ifContent,this.buttonText,this.buttonColor,
      this.textColor,this.buttonFontSize,this.buttonHeight,this.buttonWidth);
  @override
  State<StatefulWidget> createState() {
    return new CalcButtonState();
  }
}
class CalcButtonState extends State<CalcButtonWidget>{
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Text(widget.buttonText,
          style: TextStyle(fontSize: widget.buttonFontSize,color: widget.textColor)),
      constraints:BoxConstraints(
        minWidth: widget.buttonWidth,minHeight: widget.buttonHeight,),
      fillColor: widget.buttonColor,
      elevation: 2.0,
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)),),
      onPressed: (){
        if(widget.ifContent) widget.func(widget.buttonText);
        else widget.func();
      },
    );
  }
}
