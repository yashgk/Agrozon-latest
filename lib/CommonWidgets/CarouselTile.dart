import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/AppConstants/AppConstant.dart';
import 'package:flutter/material.dart';

class CarouselTile extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;
  CarouselTile(
      {@required this.label, @required this.imagePath, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        height: 130,
        width: 100,
        child: Column(
          children: [
            Image.asset(imagePath),
            AppConstant.sizer(context: context, h: 0.015, w: 0.0),
            Text(
              label,
              style: TextStyle(
                  color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.darkGreyColor,
          // boxShadow: [
          //   BoxShadow(
          //       color: AppColors.blackColor,
          //       blurRadius: 1,
          //       offset: Offset(0.9, 0.9),
          //       spreadRadius: 0.1)
          // ]
        ),
      ),
    );
  }
}
