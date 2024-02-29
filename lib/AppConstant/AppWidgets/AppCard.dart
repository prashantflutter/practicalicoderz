import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'TextWidgets.dart';

Widget MyCard({
  bool isDebit = false,
  required String title,required String valueTitle,
  required String category,required String valueCategory,
  required String type,required String valueType,
  required String refNo,required String valueRef,
  required String date,required String valueDate,
  required String amount,required String valueAmount,
}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 2),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            NameText(name: title, text: valueTitle,fontSize1: 16,fontSize2: 14),
            NameText(name: category, text: valueCategory,fontSize1: 16,fontSize2: 14),
            NameText(name: type, text: valueType,fontSize1: 16,fontSize2: 14),
            NameText(name: refNo, text: valueRef,fontSize1: 16,fontSize2: 14),
            NameText(name: date, text: valueDate,fontSize1: 16,fontSize2: 14),
            NameText(name: amount, text: valueAmount,fontSize1: 16,fontSize2: 14,color2:isDebit?Colors.redAccent:Colors.green),
          ],
        ),
      ),
    ),
  );
}


Widget MyCard2({
  bool isDebit = false,
  required String title,required String valueTitle,
  required String category,required String valueCategory,
  required String type,required String valueType,
  required String refNo,required String valueRef,
  required String date,required String valueDate,
  required String amount,required String valueAmount,
   void Function(int)? onPopMenu
}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameText(name: title, text: valueTitle,),
                NameText(name: category, text: valueCategory,),
                NameText(name: date, text: valueDate,),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  NameText(name: type, text: valueType,),
                  NameText(name: refNo, text: valueRef,),
                  NameText(name: amount, text: '₹ $valueAmount',color2:isDebit?Colors.redAccent:Colors.green),
              
                ],),
              ),
            ),
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text("Edit Details"),
                      )
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text("Delete"),
                      )
                    ],
                  ),
                ),
              ],
              offset: Offset(-30, 20),
              color: Colors.white,
              elevation: 2,
              onSelected: onPopMenu,
            )
            // IconButton(onPressed: onPopMenu, icon: Icon(CupertinoIcons.ellipsis_vertical,))
          ],
        ),
      ),
    ),
  );
}