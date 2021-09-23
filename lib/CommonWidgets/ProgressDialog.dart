import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String text;
  ProgressDialog({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColors.transparent,
        child: Container(
          margin: EdgeInsets.all(16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                SizedBox(width: 5),
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.blackColor),
                ),
                SizedBox(width: 25),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
