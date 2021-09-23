import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/AppConstants/AppConstant.dart';
import 'package:agrozon/AppConstants/AppString.dart';
import 'package:agrozon/Pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpValidate extends StatefulWidget {
  final String phoneNumber;
  OtpValidate({@required this.phoneNumber});
  @override
  _OtpValidateState createState() => _OtpValidateState();
}

class _OtpValidateState extends State<OtpValidate> {
  TextEditingController otpController = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  Future<void> signInWithPhone(BuildContext context) async {
    await firebaseAuth.verifyPhoneNumber(
      timeout: Duration(seconds: 60),
      phoneNumber: widget.phoneNumber,
      //on verification complete
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential cred =
            await firebaseAuth.signInWithCredential(credential);
        if (cred.user != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        SnackBar snackBar = SnackBar(content: Text('Invalid OTP'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      codeSent: (String verificationId, int resendToken) async {
        print("Code sent");
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        print("Auto retrival time out");
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  @override
  void initState() {
    signInWithPhone(context);
    super.initState();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColors.darkSlateGreyColor, width: 4.0),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        color: AppColors.whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppString.otpLable,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: AppColors.darkGreyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            AppConstant.sizer(context: context, h: 0.03, w: 0.0),
            PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(color: AppColors.darkGreyColor),
              controller: otpController,
              submittedFieldDecoration: BoxDecoration(
                border: Border.all(color: AppColors.darkGreyColor, width: 4.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              selectedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration.copyWith(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: AppColors.darkGreyColor, width: 4.0),
              ),
            ),
            AppConstant.sizer(context: context, h: 0.02, w: 0.0),
            SizedBox(
              width: 50,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential cred = await firebaseAuth
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationId,
                            smsCode: otpController.text));

                    if (cred.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    }
                  } catch (e) {
                    print(e.toString());
                    SnackBar snackBar = SnackBar(content: Text('Invalid OTP'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  AppString.otpSubmitBtnText,
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.darkGreyColor,
                  elevation: 5.0,
                  shadowColor: AppColors.darkGreyColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
