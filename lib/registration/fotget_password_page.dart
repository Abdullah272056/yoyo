import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/background/background.dart';
import 'package:aws_exam_portal/registration/verification_reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../gradiant_icon.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPasswordScreen> {
  TextEditingController? _emailController = new TextEditingController();
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
        // backgroundColor: Colors.backGroundColor,
        body: SizedBox(
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

                          _buildTextFieldEmail(
                            // hintText: 'Phone Number',
                            obscureText: false,
                            prefixedIcon:  GradientIcon(
                              Icons.email,
                              24,
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

                            labelText: "Email",
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
                )

              ],
            )



        ),
      ),
    );


  }


  Widget _buildTextFieldEmail({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Container(
      color: Colors.transparent,
      child: TextField(
        controller: _emailController,
        cursorColor: Colors.awsCursorColor,
        cursorWidth: 1.5,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          labelText: labelText,
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
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }



  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        String emailTxt = _emailController!.text;
        if (_inputValid(emailTxt) == false) {

          _sendEmailForOtp(emailTxt);
        } else {}


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
  _sendEmailForOtp(String email) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _showLoadingDialog(context);
        try {
          Response response = await post(
              Uri.parse('$BASE_URL_API$SUB_URL_API_FORGRT_PASSWORD'),
              body: {
                'email': email,
              });
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            setState(() {
             // _showToast("success");
              var data = jsonDecode(response.body.toString());
              userId = data['data']["user_id"].toString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VerificationResetPasswordScreen(userId)));
            });
          } else if (response.statusCode == 401) {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
          } else {
            var data = jsonDecode(response.body.toString());
            //print(data['message']);
            _showToast(data['message']);
          }
        } catch (e) {
          Navigator.of(context).pop();
          print(e.toString());
        }
      }
    } on SocketException catch (_) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }


  _inputValid(String email) {
    if (email.isEmpty) {
      _showToast("E-mail can't empty");
      return;
    }
    if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _showToast("Enter valid email");
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
        backgroundColor: Colors.awsMixedColor,
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
                          backgroundColor: Colors.awsEndColor,
                          color: Colors.awsStartColor,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Checking...",
                          style: TextStyle(fontSize: 20,color: Colors.awsMixedColor),
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
