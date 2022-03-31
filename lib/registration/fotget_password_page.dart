import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/registration/verification_reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../gradiant_icon.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordScreen> {
  TextEditingController? phoneNumber = new TextEditingController();
  bool _isObscure = true;
  bool _isCountingStatus=false;
  String _time="4:00";
  late Timer _timer;
  int _start = 4 * 60;

  late String userId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.backGroundColor,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(
                top: 10,
                bottom: 60,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/aws.png",
                          width: 180,
                          height: 90,
                        )
                      ],
                    ),
                  ),
                  // Image.asset('assets/images/profile.jpg'),
                  const Text(
                    "",
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  // Image.asset('assets/images/profile.jpg'),
                  const SizedBox(
                    height: 60,
                  ),

                _buildTextFieldPhone(
                  // hintText: 'Phone Number',
                  obscureText: false,
                  prefixedIcon:  GradientIcon(
                    Icons.phone,
                    26,
                    LinearGradient(
                      colors: <Color>[
                        Colors.awsStartColor,
                        Colors.awsStartColor,
                        Colors.awsEndColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  labelText: "Phone Number",
                ),

                  const SizedBox(
                    height: 40,
                  ),

                  _buildNextButton(),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




  Widget _buildTextFieldPhone({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Container(
      color: Colors.transparent,
      child: TextField(
        cursorColor: Colors.appRed,
        cursorWidth: 1.5,
        controller: phoneNumber,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: prefixedIcon,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsEndColor, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsStartColor, width: .2),
          ),
          labelStyle: const TextStyle(
            color: Colors.hint_color,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),
        ),
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
          LengthLimitingTextInputFormatter(
            13,
          ),
        ],
      ),
    );
  }



  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VerificationResetPasswordScreen("12")));
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7))),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.awsStartColor, Colors.awsEndColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(7.0)
        ),
        child: Container(

          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Next",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


  _inputValid(String phone) {
    if (phone.isEmpty) {
      _showToast("phone can't empty");
      return;
    }

    if (phone.length < 8) {
      _showToast("phone can't smaller than 8 digit");
      return;
    }
    if (phone.length > 13) {
      _showToast("phone can't bigger than 13 digit");
      return;
    }
    return false;
  }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }



  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // return VerificationScreen();
        return Dialog(

          child: Wrap(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 20, bottom: 20),
                  child: Center(
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Colors.appRed,
                          color: Colors.black,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Checking...",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ))
            ],
            // child: VerificationScreen(),
          ),
        );
      },
    );
  }


}
