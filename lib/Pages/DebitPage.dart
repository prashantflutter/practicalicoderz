import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icoderz_task_example/AppConstant/AppWidgets/AppCard.dart';
import 'package:icoderz_task_example/AppConstant/AppWidgets/TextWidgets.dart';

import '../AppConstant/AppDialogs/AppDialog.dart';
import '../Database/SQLiteDatabase.dart';
import 'DetailPage.dart';
class DebitPage extends StatefulWidget {
  const DebitPage({super.key});

  @override
  State<DebitPage> createState() => _DebitPageState();
}

class _DebitPageState extends State<DebitPage> {

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
          log('Debit : ${getUserDataList.length}');
          final mainIndex = getUserDataList[index];
          var type = mainIndex['type'];
      return getUserDataList.isNotEmpty?type == 'Debit'? MyCard2(
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
          },
          title: 'Title', valueTitle: mainIndex['title'],
          category: 'Category Name', valueCategory: mainIndex['categoryName'],
          type: 'Type', valueType: mainIndex['type'],
          refNo: 'Ref.No', valueRef: mainIndex['refNo'],
          date: 'Date', valueDate: mainIndex['date'],
          amount: 'Amount', valueAmount: mainIndex['amount'],isDebit: true,):SizedBox():
      Container(
          width: double.infinity,
          height:size.height*0.6,
          alignment: Alignment.center,
          child: MyText(text: 'Empty Data...',fontSize: 18));
    });
  }
}
