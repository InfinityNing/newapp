import 'dart:math';

bool brackets(String input){//判断括号是否合法
  List list=new List();
  int a=0;
  for(int i=0;i<input.length;i++){
    if(input[i]=='(') {
      list.add(input[i]);
      a=i;
    }
    else if(input[i]==')'){
      if(list.length==0||a==i-1) //栈顶左括号或()
        return false;
      else list.removeLast();
    }
    else continue;
  }
  if(list.length==0) return true;
  else return false;
}
bool symbols(String input){//判断运算符号是否合法
  String a='#',b='#',c='#';
  for(int i=0;i<input.length;i++){
    a=input[i];
    if(i<input.length-1) b=input[i+1];
    if(i>0) c=input[i-1];
    if((a=='+'||a=='-'||a=='×'||a=='÷')&&(b=='+'||b=='-'||b=='×'||b=='÷'))//连续两个运算符
      return false;
    if(((a=='×'||a=='÷')&&c=='(')||((a=='+'||a=='-'||a=='×'||a=='÷')&&b==')'))//乘除在最左或运算符在最右
      return false;
    if(i==input.length-1&&(a=='+'||a=='-'||a=='×'||a=='÷'))//最后为运算符
      return false;
    if(i==0&&(a=='×'||a=='÷'))//第一个为乘除
      return false;
  }
  return true;
}
bool judge(String input){//判断是否合法
  return brackets(input)&&symbols(input);
}
String improve(String input){//优化式子格式
  StringBuffer sb=new StringBuffer();
  sb.write('0');sb.write('+');//式首加0+
  for(int i=0;i<input.length;i++){
    if((input[i]=='+'||input[i]=='-')&&(i==0||input[i-1]=='('))//式首或括号内首有正负号加0
      sb.write('0');
    sb.write(input[i]);
    if(input.codeUnitAt(i)>=48&&input.codeUnitAt(i)<=57
        &&i<input.length-1&&input[i+1]=='(')//数字后有左括号加乘号
      sb.write('×');
    if(i<input.length-1&&input[i+1]=='('&&input[i]==')'){//两个括号()()
      sb.write('×');
    }
    if(input.codeUnitAt(i)>=48&&input.codeUnitAt(i)<=57&&i>0&&input[i-1]==')')//括号后有数字
      return 'ERROR';
  }
  return sb.toString();
}
String points(String input){//判断小数点，需要传入improve过后的字符串，式首肯定没有小数点
  StringBuffer sb=new StringBuffer();
  bool mark=false;
  for(int i=0;i<input.length;i++){
    if(input[i]=='.'){
      if(i<input.length-1){//不在尾
        if(input[i-1]==')')return 'ERROR';                             //小数点前是右括号
        if(input.codeUnitAt(i+1)>=48&&input.codeUnitAt(i+1)<=57
            &&!(input.codeUnitAt(i-1)>=48&&input.codeUnitAt(i-1)<=57)){//小数点后为数字，前不为数字
          sb.write('0');
          mark=true;
        }
        else if(input.codeUnitAt(i+1)>=48&&input.codeUnitAt(i+1)<=57
            &&input.codeUnitAt(i-1)>=48&&input.codeUnitAt(i-1)<=57){//小数点前后都为数字，跳过
          if(mark) return 'ERROR';//例如2.2.2
          else mark=true;         //启用标记
        }
        else return 'ERROR';
      }
      else if(i==input.length-1){//最后一位
        return 'ERROR';
      }
    }
    if(!(input.codeUnitAt(i)>=48&&input.codeUnitAt(i)<=57)&&input[i]!='.'){//不为数字不为.，重置标记
      mark=false;
    }
    sb.write(input[i]);
  }
  return sb.toString();
}
String perCent(String input){//判断百分号合理性同时改为小数
  if(input=='ERROR') return 'ERROR';
  StringBuffer sb=new StringBuffer();
  for(int i=0;i<input.length;i++){
    if(input[i]=='%'){
      if(i==0) return 'ERROR';
      if((input.codeUnitAt(i-1)>=48&&input.codeUnitAt(i-1)<=57)||input[i-1]==')')//前为数字或右括号
        sb.write('×0.01');
      else
        return 'ERROR';
      if(i<input.length-1&&input.codeUnitAt(i+1)>=48&&input.codeUnitAt(i+1)<=57)
        return 'ERROR';
    }
    else
      sb.write(input[i]);
  }
  return sb.toString();
}
String deZero(double input){//去掉结果末尾的0
  String temp=input.toStringAsFixed(8);//四舍五入到8位，主要为处理dart浮点运算精度问题(3=3.000000000000004)
  int a=temp.length-1;
  StringBuffer tsb =new StringBuffer();
  while(temp[a]=='0'){//从后扫描到0前移指针
    a--;
  }
  if(temp[a]=='.') a--;
  for(int i=0;i<=a;i++){
    tsb.write(temp[i]);
  }
  return tsb.toString();
}
String midToEnd(String mid){// 中缀表达式转为后缀表达式
  if(!judge(mid)) return 'ERROR';
  String ss=perCent(points(improve(mid)));print(ss+'.....');
  if(ss=='ERROR') return 'ERROR';
  StringBuffer sb=new StringBuffer();
  List cl=new List();//表达式转换栈
  for(int i=0;i<ss.length;i++){
    if((ss.codeUnitAt(i)>=48&&ss.codeUnitAt(i)<=57)||ss[i]=='.')//数字或小数点
      sb.write(ss[i]);
    else{                                                       //操作符或括号
      if(ss[i]=='+'||ss[i]=='-'||ss[i]=='×'||ss[i]=='÷'){
        sb.write(' ');
        if(cl.length==0){                                       //栈空
          cl.add(ss[i]);
        }
        else if((ss[i]=='×'||ss[i]=='÷')
            &&(cl.last=='+'||cl.last=='-'||cl.last=='(')){//优先级大于栈顶第一种情况，×÷大于+-(
          cl.add(ss[i]);
        }
        else if((ss[i]=='+'||ss[i]=='-')&&cl.last=='('){//优先级大于栈顶第二种情况，+-大于(
          cl.add(ss[i]);
        }
        else{
          while(cl.length>0&&cl.last!='('&&
              !((ss[i]=='×'||ss[i]=='÷')&&(cl.last=='+'||cl.last=='-'))){//优先级小于等于栈顶
            sb.write(cl.last);                                  //将栈中优先级大的弹出
            cl.removeLast();
          }
          cl.add(ss[i]);
        }
      }
      else if(ss[i]=='('){//左括号入栈
        cl.add(ss[i]);
      }
      else if(ss[i]==')'){//右括号
        while(cl.last!='('){//遇到左括号之前的全部弹出
          sb.write(cl.last);
          cl.removeLast();
        }
        cl.removeLast();//弹出左括号
      }
    }
  }
  while(cl.length!=0){//弹出剩余操作符
    sb.write(cl.last);
    cl.removeLast();
  }
  return sb.toString();
}
String cal(String input){//后缀表达式计算
  if(input=='ERROR')return 'ERROR';
  bool justNum=false;    //刚刚扫描到数字
  double iTemp=0,t1,t2;//itemp为缓存，存储一位数以上的数字
  int iTemp2=0;        //记录数字位数
  List il=new List();//栈
  String out=midToEnd(input);//后缀表达式
  if(out=='ERROR')return 'ERROR';
  print('......'+out);//-----------------------------------------
  for(int i=0;i<out.length;i++){
    if(out[i]=='+'||out[i]=='-'||out[i]=='×'||out[i]=='÷'){//加减乘除
      if(justNum){
        il.add(iTemp);
        justNum=false;
        iTemp=0;iTemp2=0;
      }
      t2=double.parse(il.last.toString());il.removeLast();
      t1=double.parse(il.last.toString());il.removeLast();
      switch(out[i])
      {
        case '+':
          il.add(t1+t2);break;
        case '-':
          il.add(t1-t2);break;
        case '×':
          il.add(t1*t2);break;
        case '÷':
          if(t2!=0) il.add(t1/t2);
          else return 'ERROR';break;
      }
    }
    else if(out.codeUnitAt(i)>=48&&out.codeUnitAt(i)<=57){//是数字
      if(!justNum){//之前没扫描到数字
        iTemp=(out.codeUnitAt(i)-48).toDouble();
        justNum=true;
      }
      else                                    //之前扫描到数字
      if(iTemp2==0)                         //没扫描到小数点
        iTemp=iTemp*10+(out.codeUnitAt(i)-48).toDouble();
      else {                                //之前扫描到小数点
        iTemp=iTemp+(out.codeUnitAt(i)-48)*pow(10,iTemp2*(-1));
        iTemp2++;
      }

    }
    else if(out[i]=='.'){//是小数点
      iTemp2++;
    }
    else{            //空格则跳过
      if(justNum){//已经扫描到数字
        il.add(iTemp);
        justNum=false;
        iTemp=0;  //重置两个标记
        iTemp2=0;
      }
    }
  }
  return deZero(il.last);
}