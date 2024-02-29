import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icoderz_task_example/AppConstant/AppWidgets/TextWidgets.dart';
import '../AppWidgets/AppButtons.dart';
import '../AppWidgets/AppTextFormFied.dart';

void showMessage({required BuildContext context,required String message}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline,size: 28,),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: MyText(text: message,fontSize: 18),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            MyButton(width: 80,title: 'OK', onPressed: () {
              Navigator.of(context).pop();
            },)
          ],
        );
      });
}

 LogoutNow({required BuildContext context,required String title, required String sub1,required String sub2,required void Function()? onPressed1,required void Function()? onPressed2}){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text(title,style: TextStyle(),),),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyButton(width:80,title: sub1, onPressed: onPressed1),
            MyButton(width:80,title: sub2, onPressed: onPressed2),
          ],
        ),

      ],
    );
  });
}

addData({
  required BuildContext context,required String value1,
  required String value2,required void Function(String?)? onChanged1,
  required void Function(String?)? onChanged2,required String typeValue,
  required void Function(String?)? onChanged,String? value,
  required List<DropdownMenuItem<String>>? items,
  required void Function()? onSubmit,
  required void Function() onTap,
  required TextEditingController dateController,
  required TextEditingController titleController,
  required TextEditingController refNoController,
  required TextEditingController amountController,
}){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text('Choose Type',style: TextStyle(),),),
      content: SingleChildScrollView(
        child: Column(
          children: [
            MYTextForm(controller: titleController, labelText: 'Enter Title'),
            Padding(
              padding:  EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyText(text: 'Type : '),
                  MyRadioButton(text: 'Credit', value: value1, onChanged: onChanged1, groupValue: typeValue),
                  MyRadioButton(text: 'Debit', value: value2, onChanged: onChanged2, groupValue: typeValue),

                ],
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
                  MyText(text: 'Category'),
                  SizedBox(width: 10,),
                  Expanded(
                    child: DropdownButton<String>(
                      value: value,
                      hint: Text('Select Type'),
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: onChanged,
                      items: items,
                    ),
                  ),
                ],
              ),
            ),
            MYTextForm(controller: refNoController, labelText: 'Enter Ref No'),
            MyDatePicker(context: context, controller: dateController,onTap: onTap),
            MYTextForm(controller: amountController, labelText: 'Enter Amount',keyboardType: TextInputType.number),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(width:100,title: 'Ok', onPressed: onSubmit),
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
      ),
    );
  });
}


Widget MyDatePicker({required BuildContext context, required TextEditingController controller,void Function()? onTap}){
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child:TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.calendar_today,color: Colors.black,),
          labelText: "Enter Date",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        readOnly: true,
        onTap: onTap,
      )
  );
}


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> MyToastMSG({required String text,IconData icon = Icons.gpp_good_outlined,Color backgroundColor = Colors.green,required BuildContext context})
{
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(icon,color: Colors.white,),
            ),
            Expanded(child: Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400))),
          ],
        ),
        backgroundColor:backgroundColor,
      ));

}

Widget MyRadioButton({required String text,required String value,required void Function(String?)? onChanged,required String groupValue}){
  return Row(
    children: [
      MyText(text: text),
      Radio(value: value, groupValue: groupValue, onChanged: onChanged),
    ],
  );
}