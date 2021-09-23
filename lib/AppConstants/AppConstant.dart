import 'package:flutter/material.dart';

class AppConstant {
  static Widget sizer({BuildContext context, double h, double w}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * h,
      width: MediaQuery.of(context).size.width * w,
    );
  }

  static void printWrapped({@required String text}) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
