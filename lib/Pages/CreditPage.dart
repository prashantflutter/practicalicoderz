import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icoderz_task_example/AppConstant/AppDialogs/AppDialog.dart';
import 'package:icoderz_task_example/AppConstant/AppWidgets/TextWidgets.dart';
import 'package:icoderz_task_example/Pages/DetailPage.dart';

import '../AppConstant/AppWidgets/AppCard.dart';
import '../Database/SQLiteDatabase.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {

  List<Map<String,dynamic>> getUserDataList = [];

  Future<void>refreshUserData()async{
    final userData = await SQLiteDatabase.getAllData();
    setState(() {
      getUserDataList = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshUserData();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: getUserDataList.length,
        itemBuilder: (context,index){
          log('Credit : ${getUserDataList.length}');
          final mainIndex = getUserDataList[index];
          var type = mainIndex['type'];
          return getUserDataList.isNotEmpty?type == 'Credit'?
          MyCard2(
            title: 'Title', valueTitle: mainIndex['title'],
            category: 'Category Name', valueCategory: mainIndex['categoryName'],
            type: 'Type', valueType: mainIndex['type'],
            refNo: 'Ref.No', valueRef: mainIndex['refNo'],
            date: 'Date', valueDate: mainIndex['date'],
            amount: 'Amount', valueAmount: mainIndex['amount'],
            onPopMenu:  (value) {
              if (value == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(
                    id: mainIndex['id'],
                    title: mainIndex['title'], type: mainIndex['type'], category:  mainIndex['categoryName'],
                    date: mainIndex['date'], refNo: mainIndex['refNo'],amount:mainIndex['amount'])));
              } else if (value == 2) {
                LogoutNow(context: context, title: 'are you sure want to delete?',
                    sub1: 'Yes', sub2: 'No', onPressed1: ()async{
                      await SQLiteDatabase.deleteData(mainIndex['id']);
                      MyToastMSG(text: 'Successfully deleted...', context: context);
                      refreshUserData().whenComplete(() => Navigator.pop(context));
                    }, onPressed2: ()=>Navigator.pop(context));
              }
            },):
          SizedBox():Container(
              width: type == 'Credit'?0:double.infinity,
              height:type == 'Credit'?0:size.height*0.6,
              alignment: Alignment.center,
              child: MyText(text: 'Empty Data...',fontSize: 18));
        });
  }

}
