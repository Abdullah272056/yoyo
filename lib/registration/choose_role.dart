import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/background/background.dart';
import 'package:aws_exam_portal/home_page/home_page_for_student.dart';
import 'package:aws_exam_portal/registration/sign_up_page_as_student.dart';
import 'package:aws_exam_portal/registration/sign_up_page_as_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../gradiant_icon.dart';
import 'fotget_password_page.dart';




class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({Key? key}) : super(key: key);
  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;



  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.backGroundColor,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Background(),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ).copyWith(top: 20),
                    child: Column(
                      children: [
                        Text(
                          "Choose Your Role",
                          style: TextStyle(
                            fontFamily: 'PT-Sans',
                            fontSize: 25,
                            color: Colors.awsMixedColor,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _buildForStudent(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildForTeacher(),
                      ],
                    ),
                  ),
                ),
              )

            ],
          )

          ,
        ),
      ),
    );
  }


  Widget _buildForStudent() {
    return InkResponse(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            width: 160,
            height: 160,
            color: Colors.white,
            child: Padding(
                 padding:  EdgeInsets.all(16.0),
              child: Center(
                child:Column(
                  children: [
                    Expanded(child:  Image.asset(
                      "assets/images/student.png",
                      width: 160,
                      height: 80,
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Student",
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 20,
                        color: Colors.awsMixedColor,
                      ),
                    ),

                  ],
                ),
              ),

            )


          ),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignUpScreenAsStudent()));

      },
    );
  }
  Widget _buildForTeacher() {
    return InkResponse(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            width: 160,
            height: 160,
            color: Colors.white,
            child: Padding(
                 padding:  EdgeInsets.all(16.0),
              child: Center(
                child:Column(
                  children: [
                    Expanded(child:  Image.asset(
                      "assets/images/teacher.png",
                      width: 160,
                      height: 80,
                    )),
                    Text(
                      "Teacher",
                      style: TextStyle(
                        fontFamily: 'PT-Sans',
                        fontSize: 20,
                        color: Colors.awsMixedColor,
                      ),
                    ),

                  ],
                ),
              ),

            )


          ),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignUpAsTeacherScreen()));

      },
    );
  }



  _inputValid(String phone, String password) {
    if (phone.isEmpty) {
      Fluttertoast.cancel();
      _showToast("Phone can't empty");
      return;
    }
    if (phone.length < 8) {
      Fluttertoast.cancel();
      _showToast("Phone can't smaller than 8 digit");
      return;
    }
    if (phone.length > 13) {
      Fluttertoast.cancel();
      _showToast("Phone can't bigger than 13 digit");
      return;
    }
    if (password.isEmpty) {
      Fluttertoast.cancel();
      _showToast("Password can't empty");
      return;
    }
    if (password.length < 8) {
      Fluttertoast.cancel();
      _showToast("Password can't smaller than 8 digit");
      return;
    }

    return false;
  }


  // _logInUser(String mobile, String password) async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('connected');
  //       _showLoadingDialog(context);
  //       try {
  //         Response response = await post(Uri.parse('$BASE_URL_API$SUB_URL_API_LOG_IN'),
  //             body: {'mobile': mobile, 'password': password});
  //         Navigator.of(context).pop();
  //         if (response.statusCode == 200) {
  //           setState(() {
  //             Fluttertoast.cancel();
  //             //_showToast("success");
  //             var data = jsonDecode(response.body.toString());
  //             saveUserInfo(data);
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) =>  NavigationBarScreen(0,HomePageScreen())));
  //             //var data=response.body.toString();
  //             print(data['data']["user_id"]);
  //           });
  //         }
  //         else if (response.statusCode == 201){
  //
  //           var data = jsonDecode(response.body);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) =>  SendUserForActiveScreen(data['data']["user_id"].toString())));
  //
  //           // var data=jsonDecode(response.body.toString());
  //           // //var data=response.body.toString();
  //           // print(data['message']);
  //           // print("UserId= "+data['data']["user_name"].toString());
  //           // print("Userphone= "+data['data']["user_phone"].toString());
  //           // print("Useremail= "+data['data']["user_email"].toString());
  //         } else if (response.statusCode == 400) {
  //           var data = jsonDecode(response.body.toString());
  //           Fluttertoast.cancel();
  //           //  _showToast(data['message'].toString());
  //           _showToast("phone or password not match!");
  //         } else {
  //           var data = jsonDecode(response.body.toString());
  //           Fluttertoast.cancel();
  //           _showToast(data['message'].toString());
  //         }
  //       } catch (e) {
  //         Fluttertoast.cancel();
  //         print(e.toString());
  //         _showToast("failed");
  //       }
  //     }
  //   } on SocketException catch (e) {
  //     Fluttertoast.cancel();
  //     _showToast("No Internet Connection!");
  //   }
  // }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.awsMixedColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // void _showAlertDialog(BuildContext context){
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       // return VerificationScreen();
  //       return Dialog(
  //         child: Wrap(
  //           children: [
  //             Container(
  //               margin: const EdgeInsets.only(
  //                   left: 15.0, right: 15.0, top: 20, bottom: 20),
  //               child: Column(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 30,
  //                     ),
  //                     child: Column(
  //                       children: [
  //                         Image.asset(
  //                           "assets/images/porzotok.png",
  //                           width: 120,
  //                           height: 65,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   // Image.asset('assets/images/profile.jpg'),
  //                   const Text(
  //                     "let's Discover Bangladesh Together",
  //                     style: TextStyle(
  //                       fontFamily: 'PT-Sans',
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.normal,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                   // Image.asset('assets/images/profile.jpg'),
  //                   const SizedBox(
  //                     height: 30,
  //                   ),
  //                   const Text(
  //                     "Verification code has been send to your mobile",
  //                     style: TextStyle(
  //                       fontFamily: 'PT-Sans',
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.normal,
  //                       color: Colors.black54,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 30,
  //                   ),
  //
  //                   //phone number input
  //                   _buildTextFieldOTPView(
  //                     hintText: 'Enter 6 digit Number',
  //                     obscureText: false,
  //                     prefixedIcon:
  //                         const Icon(Icons.phone, color: Colors.appRed),
  //                   ),
  //                   const SizedBox(
  //                     height: 30,
  //                   ),
  //
  //                   _buildVerifyButton(),
  //
  //                   const SizedBox(
  //                     height: 20,
  //                   ),
  //                   _buildVerifyQuestion(),
  //                 ],
  //               ),
  //             )
  //           ],
  //           // child: VerificationScreen(),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showLoadingDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        // return VerificationScreen();
        return Dialog(
          child: Wrap(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 30, bottom: 30),
                  child: Center(
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Colors.appRed,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Checking...",
                          style: TextStyle(fontSize: 25),
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


