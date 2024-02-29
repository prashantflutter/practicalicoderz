
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget NameText({required String name,required String text,
  FontWeight fontWeight1 = FontWeight.w700,FontWeight fontWeight2 = FontWeight.w500,
  double fontSize1 = 13,double fontSize2 = 12,Color color1 = Colors.black,
  Color color2 = Colors.black}){
  return Padding(
    padding:  EdgeInsets.only(left: 5,top: 5,bottom: 5),
    child: Row(
      children: [
        Text('$name : ',
          style: TextStyle(color:color1,fontSize: fontSize1,fontWeight: fontWeight1),),
        Text(text,
          style: TextStyle(color:color2,fontSize: fontSize2,fontWeight: fontWeight2),),
      ],
    ),
  );

}

Widget MyText({required String text,FontWeight fontWeight = FontWeight.w500,double fontSize = 14,Color color = Colors.black}){
  return Text(text,
    style: TextStyle(color:color,fontSize: fontSize,fontWeight: fontWeight),);

}
