import 'package:flutter/material.dart';
import 'package:tez_bazar/common/forms/text_field_forms.dart';

customAppBar(controller, context,currentIndex) => AppBar(
      toolbarHeight: 150, // Set this height
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text('TEZ Bazar', style: TextStyle(fontSize: 30)),
            ),
            textFieldSearch(controller),
          ],
        ),
      ),
    );
