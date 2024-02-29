import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:icoderz_task_example/AppConstant/AppWidgets/AppButtons.dart';
import 'package:icoderz_task_example/Pages/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppConstant/AppDialogs/AppDialog.dart';
import '../AppConstant/AppWidgets/AppTextFormFied.dart';
import '../AppConstant/AppWidgets/TextWidgets.dart';
import '../Controller/CategoryController.dart';
import '../Database/SQLiteDatabase.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final int id;
  final String type;
  final String category;
  final String date;
  final String refNo;
  final String amount;
   DetailPage({super.key, required this.title, required this.type, required this.category, required this.date, required this.refNo, required this.amount, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  CategoryController categoryController = Get.put(CategoryController());
  ValueNotifier updateValue = ValueNotifier(0);

  String typeValue = 'other';
  String? categoryValue;
  // List<String> items = <String>[
  //   'Salary',
  //   'Shopping',
  //   'Travelling',
  //   'Food',
  //   'Extra'
  // ];
   var index ;
  var  totalAmount;
  init()async{
    titleController.text = widget.title;
    dateController.text = widget.date;
    refNoController.text = widget.refNo;
    amountController.text = widget.amount;
    typeValue = widget.type;
    categoryValue = widget.category;
    index = widget.id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    totalAmount =   preferences.get('TotalAmount')?? 0;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
        title: Text('Details Page',style: TextStyle(color: Colors.white),),
      ),
      body: ValueListenableBuilder(
        valueListenable: updateValue,
        builder: (context,child,value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: MYTextForm(controller: titleController, labelText: 'Enter Title'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyText(text: 'Type : '),
                    MyRadioButton(text: 'Credit', value: 'Credit', onChanged: (val1){
                      typeValue = val1!;
                      // categoryController.fetchCategoryData();
                      categoryValue = 'Salary';
                      updateValue.value++;
                    }, groupValue: typeValue),
                    MyRadioButton(text: 'Debit', value: 'Debit', onChanged: (val2){
                      typeValue = val2!;
                      categoryValue = 'Shopping';
                      updateValue.value++;
                    }, groupValue: typeValue),
              
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.black,
                      )
                  ),
              
                  child: GetBuilder<CategoryController>(
                    builder: (_) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(text: 'Category : '),
                          SizedBox(width: 20,),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: categoryValue,
                                    underline: SizedBox(),
                                    icon: SizedBox(),
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    onChanged: (String? newValue) {
                                        log('value : $newValue');
                                        categoryValue = newValue!;
                                        updateValue.value++;
                                    },
                                    items: typeValue == 'Debit'?
                                    categoryController.debitListData.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value.categoryName,
                                        child: Text(value.categoryName!),
                                      );
                                    }).toList():
                                    categoryController.creditListData.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value.categoryName,
                                        child: Text(value.categoryName!),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.arrow_drop_down,size: 25,),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                ),
                MYTextForm(controller: refNoController, labelText: 'Enter Ref No'),
                MyDatePicker(context: context, controller: dateController,onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
              
                  if (pickedDate != null) {
                    print(pickedDate);
                    String formattedDate =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
                    print(formattedDate);
                    dateController.text = formattedDate;
                    updateValue.value++;
                  } else {
                    print("Date is not selected");
                  }
                }),
                MYTextForm(controller: amountController, labelText: 'Enter Amount',keyboardType: TextInputType.number),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: MyButton(title: 'Update', onPressed: (){
                    LogoutNow(context: context, title: 'are you sure to update Data?',
                        sub1: 'Yes', sub2: 'No', onPressed1: ()async{
                      var updateAmount = int.parse(amountController.text);
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                         if(typeValue == 'Debit'){
                           updateAmount = totalAmount + updateAmount;
                           await SQLiteDatabase.updateData(
                               index, titleController.text, categoryValue!, typeValue, refNoController.text,
                               dateController.text, amountController.text);
                           preferences.setInt('TotalAmount', updateAmount);
                           log('totalAmount : $totalAmount');
                           updateValue.value++;
                           MyToastMSG(text: 'successfully Updated...', context: context);
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                         }else{
                           updateAmount = totalAmount + updateAmount;
                         await SQLiteDatabase.updateData(
                             index, titleController.text, categoryValue!, typeValue, refNoController.text,
                             dateController.text, amountController.text);
                         preferences.setInt('TotalAmount', updateAmount);
                         log('totalAmount : $totalAmount');
                         updateValue.value++;
                         MyToastMSG(text: 'successfully Updated...', context: context);
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

                         }

                        }, onPressed2:() => Navigator.pop(context));
                                }),
                ),
              
              ],),
            ),
          );
        }
      ),
    );
  }
}
