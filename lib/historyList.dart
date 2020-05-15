import 'package:flutter/material.dart';

class HistoryWidget extends StatefulWidget{
  List calcHistory=new List();
  var widHeight,widWidth;
  Function clickToCalc,slideToDel,customFunc;
  HistoryWidget(this.calcHistory,this.widHeight, this.widWidth,
      this.clickToCalc,this.slideToDel,[this.customFunc]);
  @override
  State<StatefulWidget> createState() {
    return new HistoryState();
  }
}
class HistoryState extends State<HistoryWidget>{
  ScrollController _scrollController=ScrollController();
  Widget _listViewItemBuilder(BuildContext context,int index){
    return Dismissible(//滑动删除
      key: Key(widget.calcHistory[index].toString()+
          widget.calcHistory.length.toString()),
//      key是在此类中的列表中删除的对象的唯一辨识标志，括号传入string类型，如果仅使用widget.calcHistory[index]，
//      相当于用元素名字来辨识，在有连续的相同元素时会无法正确dismiss，从而报错。wdnmd研究了两个多小时
//      至于为什么不加上index.toString，试了一下发现不行就没再研究了，懒得想了
//      参见https://www.icode9.com/content-4-520050.html
      child: InkWell(//列表点击
        child: Container(
          alignment: Alignment.centerLeft,
          width: widget.widWidth,
          child: Text(widget.calcHistory[index],
            style: TextStyle(fontSize: 35,color: Color(0xAA000000)),),
        ),
        onTap:(){
          widget.clickToCalc(index);
          _scrollController.animateTo(_scrollController.position.minScrollExtent,
              duration: Duration(milliseconds: 200),curve: Curves.ease);
          if(widget.customFunc!=null) widget.customFunc();//执行专门的函数，如历史页面的返回
        },//回调
      ),
      onDismissed: (direction) {
        setState(() {
          widget.slideToDel(index);
          //删除calc类中列表的相应对象，可能由于构造使用了this，
          //虽然没在calc中setstate，但此类中的列表应该也自动刷新了
        });
      },
      dismissThresholds: {DismissDirection.endToStart:0.3,
        DismissDirection.startToEnd:0.3},
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.delete_forever,color: Colors.white,),
            Text('删除',style: TextStyle(fontSize: 18,color: Colors.white),),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('删除',style: TextStyle(fontSize: 18,color: Colors.white),),
            Icon(Icons.delete_forever,color: Colors.white,size: 18,),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.widHeight,
      width: widget.widWidth,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        reverse: true,
        itemCount: widget.calcHistory.length,
        itemBuilder: _listViewItemBuilder,
      ),
    );
  }
}