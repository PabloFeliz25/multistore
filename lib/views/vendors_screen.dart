import 'package:flutter/material.dart';
import 'package:multistore/views/header_widget.dart';
import 'package:multistore/views/vendor_widget.dart';

class VendorsScreen extends StatelessWidget {
  VendorsScreen({super.key});

  static const String id = "\VendorsScreen";


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Manage Vendors',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Row(
            children: [
              HeaderWidget.rowHeader('LOGO', 1),
              HeaderWidget.rowHeader('BUSINESS NAME', 3),
              HeaderWidget.rowHeader('CITY', 2),
              HeaderWidget.rowHeader('ACTION', 1),
              HeaderWidget.rowHeader('VIEW MORE', 1),
            ],
          ),
          VendorWidget(),
        ],
      ),
    );
  }
}
