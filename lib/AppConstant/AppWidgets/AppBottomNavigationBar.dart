
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget AppBottomNavigationBar({required BuildContext context,required int currentIndex,required void Function(int) onTap}){
  final size = MediaQuery.of(context).size;
  return BottomNavigationBar(
      backgroundColor: Colors.grey.withOpacity(0.2),
      elevation: 0,
      selectedFontSize: 14,
      selectedIconTheme:
      IconThemeData(color: Colors.black, size: size.height * 0.04),
      selectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          label: 'Credit',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on_outlined),
          label: 'Debit',
        ),
      ]);
}