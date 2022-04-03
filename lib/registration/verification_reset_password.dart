import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aws_exam_portal/background/background.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import 'new_password_set.dart';


class VerificationResetPasswordScreen extends StatefulWidget {
  final String userId;
  const VerificationResetPasswordScreen(this.userId, {Key? key})
      : super(key: key);

  @override
  State<VerificationResetPasswordScreen> createState() =>
      _VerificationResetPasswordState(this.userId);
}

class _VerificationResetPasswordState
    extends State<VerificationResetPasswordScreen> {
  late String userId;
  _VerificationResetPasswordState(this.userId);

  TextEditingController? _tfOtp = new TextEditingController();
  bool _isObscure = true;
  String _otpTxt = "";
  bool _isCountingStatus=false;
  String _time="4:00";
  late Timer _timer;
  int _start = 4 * 60;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    //countDown();
    startTimer();
    // passwordController=TextEditingController(text:SharedPref().readUserId());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState changed: $state");
    if (state == AppLifecycleState.resumed) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    //_otpCountDown.cancelTimer();
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.backGroundColor,
        body:
        SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:Stack(
              children: [
                Background(),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ).copyWith(
                        top: 10,
                        bottom: 10,
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

                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Verification code has been send to your mobile",
                            style: TextStyle(
                              fontFamily: 'PT-Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.awsColor,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          //phone number input
                          _buildTextFieldOTPView(
                            hintText: 'Enter 6 digit Number',
                            obscureText: false,
                            prefixedIcon: const Icon(Icons.phone, color: Colors.appRed),
                          ),
                          const SizedBox(
                            height: 50,
                          ),

                          _buildNextButton(),

                          const SizedBox(
                            height: 20,
                          ),
                          _buildVerifyQuestion(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isCountingStatus=true;
          });
        } else {
          setState(() {
            _start--;
            final df = DateFormat('mm:ss');
            _time=df.format(new DateTime.fromMillisecondsSinceEpoch(_start*1000)).toString();
            // timetxt=df.format(new DateTime.fromMillisecondsSinceEpoch(_start*1000));

          });
        }
      },
    );
  }

  Widget _buildTextFieldOTP({
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
        controller: _tfOtp,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: prefixedIcon,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.appRed, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.appRed, width: .1),
          ),
          labelStyle: TextStyle(
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
      ),
    );
  }

  Widget _buildTextFieldOTPView({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Container(
      color: Colors.transparent,
      child: OTPTextField(
        length: 6,
        width: MediaQuery.of(context).size.width,
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.box,
        fieldWidth: 40,
        style: TextStyle(
          fontSize: 18,
          color: Colors.green,
        ),
        keyboardType: TextInputType.number,
        onCompleted: (pin) {
          _otpTxt = pin;
        },
        onChanged: (value) {
          if (value.length < 6) {
            _otpTxt = "";
          }
        },
      ),
    );
  }



  Widget _buildNextButton() {
    return ElevatedButton(
        onPressed: () {
          if (_otpTxt.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewPasswordSetScreen("12")));
            // _verifyAfterResetPassword(user_id: userId, otp_code: _otpTxt);
          }
          else if (_otpTxt.length < 6) {
            Fluttertoast.cancel();
            _showToast("Please input 6 digit Number");
          }
          else {
            _showToast("Please input valid otp");
          }

          // Navigator.push(context,MaterialPageRoute(builder: (context)=>VerificationScreen()));
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
            'VERIFY',
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

  Widget _buildVerifyQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        if(_isCountingStatus==false)...[
          const Text(
            "After 240 second,The otp will be invalid!",

            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            _time,
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ]
        else if(_isCountingStatus==true)...[
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Don't get the verification code?",
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 13,
              color: Colors.black45,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            child: const Text(
              'Send Code',
              style: TextStyle(
                fontFamily: 'PT-Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            onTap: () {

              //_reSendCode( user_id: userId);
              // Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
            },
          ),
        ],
      ],
    );
  }

  // _verifyAfterResetPassword({
  //   required String user_id,
  //   required String otp_code,
  // }) async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       _showLoadingDialog(context,"Verifying...");
  //       try {
  //         Response response = await get(
  //           Uri.parse(
  //               '$BASE_URL_API$SUB_URL_API?user_id=$userId&code=$otp_code'),
  //         );
  //         Navigator.of(context).pop();
  //         print("StatusCodeVerify=" + response.statusCode.toString());
  //         if (response.statusCode == 200) {
  //           _showToast("success");
  //           // var data=jsonDecode(response.body.toString());
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) =>
  //                       NewPasswordSetScreen(user_id.toString())));
  //         } else if (response.statusCode == 400) {
  //           var data = jsonDecode(response.body.toString());
  //           _showToast(data['message']);
  //         } else {
  //           var data = jsonDecode(response.body.toString());
  //           _showToast(data['message']);
  //         }
  //       } catch (e) {
  //         print(e.toString());
  //         Navigator.of(context).pop();
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     Fluttertoast.cancel();
  //     _showToast("No Internet Connection!");
  //   }
  // }


  // startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //         (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //           _isCountingStatus=true;
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //           final df = DateFormat('mm:ss');
  //           _time=df.format(new DateTime.fromMillisecondsSinceEpoch(_start*1000)).toString();
  //           // timetxt=df.format(new DateTime.fromMillisecondsSinceEpoch(_start*1000));
  //
  //         });
  //       }
  //     },
  //   );
  // }

  // _reSendCode({required String user_id}) async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('connected');
  //       _showLoadingDialog(context,"Sending...");
  //       try {
  //         Response response = await put(
  //           Uri.parse('$BASE_URL_API$SUB_URL_API_RESEND_OTP$user_id/'),
  //         );
  //         Navigator.of(context).pop();
  //         if (response.statusCode == 200) {
  //           _showToast("Check your message");
  //           _start = 4 * 60;
  //           _isCountingStatus=false;
  //           _time="4:00";
  //           setState(() {
  //             _timer.cancel();
  //             startTimer();
  //           });
  //         } else if (response.statusCode == 400) {
  //           var data = jsonDecode(response.body.toString());
  //           _showToast(data['message']);
  //         } else {
  //           var data = jsonDecode(response.body.toString());
  //           _showToast(data['message']);
  //         }
  //       } catch (e) {
  //         print(e.toString());
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     Fluttertoast.cancel();
  //     _showToast("No Internet Connection!");
  //   }
  // }

  void _showLoadingDialog(BuildContext context,message) {
    showDialog(
      context: context,
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

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.awsColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
