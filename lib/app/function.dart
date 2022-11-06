import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';




void dPrint(String message, {int level = 1,String? tag}) {
  if (kDebugMode) {
    var a = StackTrace.current;
    final regexCodeLine = RegExp(r" (\(.*\))$");
    var i = regexCodeLine
        .stringMatch(a.toString().split("\n")[level])
        .toString()
        .replaceAll("(", "")
        .replaceAll(")", "").trim()/*.split("/")*/;
        var tPrent = "$i\n${tag!=null?tag+": ":""}$message";
    if (message.length > 1800) {
      log(tPrent);
    } else {
      print(tPrent);
    }
  }
}

bool isEmailValid(String mail)=> RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail);

bool isPhoneValid(String phone)=> RegExp(r"^01[0125][0-9]{8}$").hasMatch(phone);
