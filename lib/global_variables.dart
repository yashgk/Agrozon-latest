import 'package:flutter/material.dart';
import 'AppConstants/AppColors.dart';

OutlineInputBorder textFieldBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.darkSlateGreyColor,
  ),
  borderRadius: BorderRadius.circular(12),
);

OutlineInputBorder textFieldEnabledBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.darkGreyColor,
  ),
  borderRadius: BorderRadius.circular(12),
);
