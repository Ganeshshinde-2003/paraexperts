import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paraexpert/core/theme/color_pallete.dart';

class ConfirmExitDialog {
  static Future<bool> showExitConfirmationDialog(BuildContext context) async {
    final Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm Exit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Do you want to exit the app?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                completer.complete(false);
                Navigator.of(context).pop(false);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                  child: Text('No',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                completer.complete(true);
                exit(0);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 2,
                    bottom: 2,
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return completer.future;
  }
}
