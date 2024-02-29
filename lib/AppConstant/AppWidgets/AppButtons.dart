import 'package:flutter/material.dart';

Widget MyButton({required String title,double width = 130,required void Function()? onPressed,Color? backgroundColor,bool isColor = false}){
  return Container(
      width: width,
      height: 50,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: backgroundColor,elevation: 2),
          onPressed: onPressed, child: Text(title,style: TextStyle(fontSize: 16,color: isColor?Colors.white:Colors.black),)));
}