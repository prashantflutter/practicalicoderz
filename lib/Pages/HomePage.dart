import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:icoderz_task_example/AppConstant/AppWidgets/AppBottomNavigationBar.dart';
import 'package:icoderz_task_example/Controller/CategoryController.dart';
import 'package:icoderz_task_example/Pages/CreditPage.dart';
import 'package:icoderz_task_example/Pages/DebitPage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppConstant/AppDialogs/AddDataDialog.dart';
import '../AppConstant/AppDialogs/AppDialog.dart';
import '../AppConstant/AppWidgets/TextWidgets.dart';
import '../Database/SQLiteDatabase.dart';
import '../Service/FirebaseService.dart';
import 'SignInPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController refNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  static const List<Widget> _pages = <Widget>[
    CreditPage(),
    DebitPage(),
  ];

  int _selectedIndex = 0;
  var totalAmount;
  String? typeValue;
  String? categoryValue;
  List<Map<String,dynamic>> getUserDataList = [];

  CategoryController cateController = Get.put(CategoryController());


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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('HomePage',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: size.width * 0.53,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user!.photoURL!),
                            radius: 25,
                          ),
                          NameText(name: 'Name', text: user!.displayName!,fontSize1: 11,fontSize2: 11),
                          NameText(name: 'Email', text: user!.email!,fontSize1: 11,fontSize2: 11),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.43,
                      height: size.height * 0.07,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: NameText(
                              name: 'Total Amount',
                              text: totalAmount.toString(),
                              fontWeight1: FontWeight.w500,
                              fontSize1: 12,
                              fontSize2: 12),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.43,
                      height: size.height * 0.07,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyText(text: 'Logout'),
                            IconButton(
                                onPressed: () {
                                  FirebaseService service = new FirebaseService();
                                  LogoutNow(
                                      context: context,
                                      title: 'are you sure want to logout?',
                                      sub1: 'Yes',
                                      sub2: 'No',
                                      onPressed1: () async {
                                        await service.signOutFromGoogle();
                                        await SQLiteDatabase.deleteAllData();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInPage()));
                                      },
                                      onPressed2: () {
                                        Navigator.pop(context);
                                      });
                                },
                                icon: Icon(Icons.logout)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _pages.elementAt(_selectedIndex), //New
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(context: context, currentIndex: _selectedIndex, onTap: _onItemTapped),
      floatingActionButton: GetBuilder<CategoryController>(
        builder: (_) {
          return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                     showDialog(context: context, builder: (context) => MyForm(onSubmit:onSubmit ));
              });
        }
      ),
    );
  }

  void onSubmit(String result) {
    print(result);
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
      refreshUserData().whenComplete(() => Navigator.pop(context));
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
      categoryValue = '';
      refreshUserData().whenComplete(() => Navigator.pop(context));
      MyToastMSG(text: 'successfully added Data...', context: context);
    }else{
      log('totalAmount : $totalAmount');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


}
