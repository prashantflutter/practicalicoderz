import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/categoryModel.dart';

class CategoryController extends GetxController{


  @override
  void onInit() {
    fetchCategoryData();
    super.onInit();
  }
  final Dio dio = Dio();
  List<CreditCategory> creditListData = [];
  List<DebitCategory> debitListData = [];
  Future<void> fetchCategoryData() async {
    try {
      var url = 'https://mocki.io/v1/e81f728b-acf4-4025-8dd9-2a4b2b8a4e18';
      var response = await dio.get(url);
      log('Response : ${response.data}');
      CategoryModel categoryModel = CategoryModel.fromJson(response.data);
      if(response.statusCode == 200){
        log('Response 200 : ${response.data}');
        debitListData.addAll((categoryModel.debitCategory)!.map((e) => DebitCategory.fromJson(e.toJson())));
        creditListData.addAll((categoryModel.creditCategory)!.map((e) => CreditCategory.fromJson(e.toJson())));

      }else{
        // showMessage(context: context, message: 'Something went to wrong!');
        log('Error fetching data: Something went to wrong!');
      }
    } catch (error) {
      log('Error fetching data: $error');
      throw error;
    }
  }
}