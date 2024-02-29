

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:icoderz_task_example/Pages/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/CategoryController.dart';
import '../../Database/SQLiteDatabase.dart';
import '../AppWidgets/AppButtons.dart';
import '../AppWidgets/AppTextFormFied.dart';
import '../AppWidgets/TextWidgets.dart';
import 'AppDialog.dart';


typedef void MyFormCallback(String result);

class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;
  MyForm({required this.onSubmit});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {

  TextEditingController titleController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  CategoryController categoryController = Get.put(CategoryController());
  ValueNotifier updateValue = ValueNotifier(0);

  var totalAmount;
  String? typeValue;
  String? categoryValue;
  List<Map<String,dynamic>> getUserDataList = [];


  Future<void>refreshUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userData = await SQLiteDatabase.getAllData();
    setState(() {
      totalAmount = preferences.getInt('TotalAmount')?? 0;
      getUserDataList = userData;
    });
  }

  @override
  void initState() {
    refreshUserData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: updateValue,
      builder: (context,child,value) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: Center(child: Text('Choose Type',style: TextStyle(),),),
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  MYTextForm(controller: titleController, labelText: 'Enter Title'),
                  Padding(
                    padding:  EdgeInsets.only(left: 15),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyText(text: 'Type : '),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: MyText(text: 'Credit'),
                          ),
                          Radio(
                              value: 'Credit',
                              groupValue: typeValue,
                              visualDensity: VisualDensity.compact,
                              onChanged:(val1) {
                                typeValue = val1!;
                                log('typeValue 1: $typeValue');
                                updateValue.value++;
                              }),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: MyText(text: 'Debit'),
                          ),
                          Radio(
                              value: 'Debit',
                              groupValue: typeValue,
                              visualDensity: VisualDensity.compact,
                              onChanged:  (val2) {
                                typeValue = val2!;
                                log('typeValue 2: $typeValue');
                                updateValue.value++;
                              }),
                        ]
                    ),
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

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(text: 'Category : '),
                        SizedBox(width: 10,),
                        Expanded(
                          child:DropdownButton<String>(
                            hint: Text('Select Category'),
                            value: categoryValue,
                            underline: SizedBox(),
                            icon: SizedBox(),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
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
                        Icon(Icons.arrow_drop_down_outlined,)
                      ],
                    ),
                  ),
                  MYTextForm(controller: refNoController, labelText: 'Enter Ref No'),
                  MyDatePicker(
                    context: context,
                      controller: dateController,
                      onTap: ()async {
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

                  setState(() {
                  dateController.text = formattedDate;
                  });
                  } else {
                  print("Date is not selected");
                  }
                  }, ),
                  MYTextForm(controller: amountController, labelText: 'Enter Amount',keyboardType: TextInputType.number),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyButton(width:100,title: 'Ok', onPressed: (){
                          checkValidation();
                        }),
                        MyButton(width:100,title: 'Cancel', onPressed: (){
                          titleController.clear();
                          refNoController.clear();
                          amountController.clear();
                          dateController.clear();
                          Navigator.pop(context);}),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }

  void checkValidation()async{
    String title = titleController.text;
    String categoryName = categoryValue!;
    String type = typeValue!;
    String refNo = refNoController.text;
    String date = dateController.text;
    String amount = amountController.text;
    var updateAmount;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if(title.isEmpty|| categoryName.isEmpty || type.isEmpty || refNo.isEmpty || date.isEmpty || amount.toString().isEmpty){
      showMessage(context: context, message: 'please fill all details!');
    }else if(type == 'Credit'){
      updateAmount = totalAmount + int.parse(amount);
      totalAmount = updateAmount;
      preferences.setInt('TotalAmount', totalAmount);
      log('totalAmount : $totalAmount');
      await SQLiteDatabase.createData(title, categoryName, type, refNo, date, amount);
      titleController.clear();
      refNoController.clear();
      amountController.clear();
      dateController.clear();
      typeValue = 'other';
      categoryValue = 'Salary';
      refreshUserData().whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage())));
      MyToastMSG(text: 'successfully added Data...', context: context);
    }else if(type == 'Debit'){
      updateAmount = totalAmount - int.parse(amount);
      totalAmount = updateAmount;
      preferences.setInt('TotalAmount', totalAmount);
      log('totalAmount : $totalAmount');
      await SQLiteDatabase.createData(title, categoryName, type, refNo, date, amount.toString());
      titleController.clear();
      refNoController.clear();
      amountController.clear();
      dateController.clear();
      typeValue = 'other';
      categoryValue = 'Shopping';
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
      MyToastMSG(text: 'successfully added Data...', context: context);
    }else{
      log('totalAmount : $totalAmount');
    }
  }

}