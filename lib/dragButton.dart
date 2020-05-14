import 'package:flutter/material.dart';

class DragButton extends StatefulWidget{
  Function func;
  Color widColor=Colors.black;
  String widText;
  double buttonFontSize,buttonHeight,buttonWidth;
  DragButton(this.func,this.widText,this.widColor,
      this.buttonFontSize,this.buttonHeight,this.buttonWidth);

  @override
  State<StatefulWidget> createState() {
    return new DragButtonState();
  }
}
class DragButtonState extends State<DragButton>{
  var originPosX,newPosX,newPosY;
  String temp=' ';
  List orientationList=[Orientation.landscape,Orientation.portrait];
  List coordinateList=[[0.0,0.0],[0.0,0.0]];
  OverlayEntry overlayEntry;
  _updateCoordinateList(){
    coordinateList=[[newPosX-120,newPosY-30],[newPosX-30,newPosY-110]];
  }
  _buildOverlay(){
    overlayEntry=new OverlayEntry(builder: (context) {//开始滑动，构造悬浮控件
      return Positioned(
        left: coordinateList[orientationList.indexOf(MediaQuery.of(context).orientation)][0],
        top: coordinateList[orientationList.indexOf(MediaQuery.of(context).orientation)][1],
        child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            width: 60, height: 60,
            decoration: new BoxDecoration(color: Colors.white,
              border: Border.all(color: Colors.grey,width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Material(
                color: Colors.white,
                child: Text(temp, style: TextStyle(fontSize: 30,color: Colors.black),),
              ),
            ),
          ),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails e){
        setState(() {
          newPosX=originPosX=e.globalPosition.dx;
          newPosY=e.globalPosition.dy;
          _updateCoordinateList();
          _buildOverlay();
          Overlay.of(context).insert(overlayEntry);//插入悬浮控件
        });
      },
      onPanUpdate: (DragUpdateDetails e){
        setState(() {
          newPosX+=e.delta.dx;newPosY+=e.delta.dy;//坐标更新
          if(newPosX-originPosX>=0) temp=')';
          else temp='(';
          _updateCoordinateList();
          overlayEntry.markNeedsBuild();//标记控件需要更新
        });
      },
      onPanEnd: (DragEndDetails e){
        setState(() {
          overlayEntry.remove();      //松手，悬浮控件移除
          if(newPosX-originPosX>=0) widget.func(')');//右滑
          else widget.func('(');//左滑
        });
      },
      child: RawMaterialButton(
        child: Text(widget.widText,
            style: TextStyle(fontSize: widget.buttonFontSize,color: Colors.black)),
        constraints:BoxConstraints(
          minWidth: widget.buttonWidth, minHeight: widget.buttonHeight,),
        fillColor: widget.widColor,
        elevation: 2.0,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),),
        onPressed: (){},
      ),
    );
  }
}
