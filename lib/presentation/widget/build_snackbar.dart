import 'package:flutter/material.dart';

SnackBar buildSnackBarNotify({required String textNotify, Color? backgroundColor}) {
  return SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    duration: Duration(milliseconds: 1500),
    content: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            backgroundColor == Colors.red ? Icons.error : Icons.check_circle, 
            color: backgroundColor == Colors.red ? Colors.red : Colors.green, 
            size: 24
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              textNotify,
              style: TextStyle(
                fontSize: 15, 
                color: backgroundColor == Colors.red ? Colors.white : Colors.black
              ),
            ),
          ),
          TextButton(
            onPressed: () {}, 
            child: Text(
              "Undo",
              style: TextStyle(
                color: backgroundColor == Colors.red ? Colors.white : Colors.black
              )
            )
          ),
        ],
      ),
    ),
  );
}

SnackBar buildSnackBarNotifyError({required String textNotify}) {
  return SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    duration: Duration(milliseconds: 500),
    content: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              textNotify,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          TextButton(onPressed: () {}, child: Text("Undo")),
        ],
      ),
    ),
  );
}