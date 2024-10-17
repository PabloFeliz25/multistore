import 'package:flutter/material.dart';

class HeaderWidget {

  static Widget rowHeader(String text, int flex) {
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade700,
              ),
              color: Colors.yellow.shade900),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}