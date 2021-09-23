import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/AppConstants/AppConstant.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData leading;
  final VoidCallback onListItemTap;
  CustomListTile({this.title, this.leading, this.onListItemTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.darkGreyColor,
          borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onListItemTap,
        child: Row(
          children: [
            Icon(
              leading,
              color: AppColors.whiteColor,
            ),
            AppConstant.sizer(context: context, w: 0.05, h: 0.0),
            Text(
              title,
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
