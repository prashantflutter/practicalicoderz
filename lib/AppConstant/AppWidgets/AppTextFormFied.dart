

import 'package:flutter/material.dart';

Widget MYTextForm({required TextEditingController controller,required String labelText,TextInputType? keyboardType}){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    ),
  );
}
