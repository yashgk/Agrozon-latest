import 'dart:io';
import 'dart:ui';
import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/AppConstants/AppConstant.dart';
import 'package:agrozon/AppConstants/AppString.dart';
import 'package:agrozon/Core/RealtimeDatabase.dart';
import 'package:agrozon/Core/Prefs.dart';
import 'package:agrozon/Model/UserModel.dart';
import 'package:agrozon/Pages/HomePage.dart';
import 'package:agrozon/Pages/OtpValidate.dart';
import 'package:agrozon/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agrozon/Core/AuthBase.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController phoneController = TextEditingController();
  bool connected;
  void checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
      } else {
        connected = false;
      }
    } on SocketException catch (e) {
      connected = false;
      print(e.toString());
    }
  }

  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: AppColors.whiteColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppConstant.sizer(context: context, h: 0.05, w: 0.0),
            Image.asset(
              'assets/images/loginbg.png',
              height: 200,
              width: 300,
            ),
            AppConstant.sizer(context: context, h: 0.05, w: 0.0),
            Container(
              // padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.whiteColor,
                // boxShadow: [
                //   BoxShadow(
                //       color: AppColors.blackColor,
                //       offset: Offset(1.0, 1.0),
                //       spreadRadius: 0,
                //       blurRadius: 1),
                // ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppString.loginLable,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: AppColors.darkGreyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  AppConstant.sizer(context: context, h: 0.012, w: 0.0),
                  Text(
                    AppString.loginMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.darkSlateGreyColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  AppConstant.sizer(context: context, h: 0.012, w: 0.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: TextField(
                      showCursor: false,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      controller: phoneController,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      cursorColor: AppColors.darkGreyColor,
                      decoration: InputDecoration(
                        counterText: '',
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(10, 11, 0, 0),
                          child: Text(
                            ' +91 ',
                            style: TextStyle(
                                fontSize: 20,
                                color: AppColors.darkGreyColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        border: textFieldEnabledBorder,
                        disabledBorder: textFieldEnabledBorder,
                        enabledBorder: textFieldEnabledBorder,
                        focusedBorder: textFieldEnabledBorder,
                      ),
                      style: TextStyle(
                          letterSpacing: 2.0,
                          fontSize: 20,
                          color: AppColors.darkGreyColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  AppConstant.sizer(context: context, h: 0.012, w: 0.0),
                  ElevatedButton(
                    onPressed: () async {
                      String phoneNumber = "+91" + phoneController.text.trim();
                      print(phoneNumber);
                      if (phoneNumber.length == 13) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpValidate(
                              phoneNumber: phoneNumber,
                            ),
                          ),
                        );
                      } else {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            'Please Enter Valid Phone Number.',
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: AppColors.errorColor,
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      AppString.submitBtn,
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.darkGreyColor,
                      elevation: 0.0,
                      shadowColor: AppColors.darkGreyColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  )
                ],
              ),
            ),
            AppConstant.sizer(context: context, h: 0.03, w: 0.0),
            Text(
              AppString.loginOption,
              style: TextStyle(
                  color: AppColors.darkSlateGreyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            AppConstant.sizer(context: context, h: 0.03, w: 0.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    checkConnectivity();
                    if (connected == true) {
                      User cred = await Auth.signInWithGoogle();

                      if (cred != null) {
                        Prefs.setUser(cred);

                        AppUser finaluser = await Prefs.getUser();

                        RealtimeDatabase.addUserData(finaluser);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      } else {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            'Something Went Wrong. Please Try Again.',
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: AppColors.errorColor,
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          'Please Connect to the Internet.',
                          style: TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: AppColors.warningColor,
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.darkSlateGreyColor,
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: AppColors.blackColor,
                      //       offset: Offset(1.0, 1.0),
                      //       spreadRadius: 0,
                      //       blurRadius: 1),
                      // ],
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Image.asset('assets/icons/google.png'),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    checkConnectivity();
                    if (connected) {
                      User cred = await Auth.signInWithFacebook();
                      if (cred != null) {
                        Prefs.setUser(cred);
                        AppUser finaluser = await Prefs.getUser();
                        RealtimeDatabase.addUserData(finaluser);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      } else {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            'Something Went Wrong. Please Try Again.',
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: AppColors.errorColor,
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          'Please Connect to the Internet.',
                          style: TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: AppColors.warningColor,
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.darkSlateGreyColor,
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: AppColors.blackColor,
                      //       offset: Offset(1.0, 1.0),
                      //       spreadRadius: 0,
                      //       blurRadius: 1),
                      // ],
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Image.asset('assets/icons/facebook.png'),
                  ),
                ),
              ],
            ),
            AppConstant.sizer(context: context, w: 0.0, h: 0.1),
          ],
        ),
      ),
    );
  }
}
