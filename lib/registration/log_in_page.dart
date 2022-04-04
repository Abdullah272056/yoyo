import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/background/background.dart';
import 'package:aws_exam_portal/home_page/home_page.dart';
import 'package:aws_exam_portal/home_page/home_page_for_teacher.dart';
import 'package:aws_exam_portal/registration/sign_up_page_as_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../gradiant_icon.dart';
import 'choose_role.dart';
import 'fotget_password_page.dart';




class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/aws.png",
                                width: 160,
                                height: 80,
                              )
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        //phone number input
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
                          // prefixedIcon: const Icon(Icons.phone, color: Colors.appRed),
                          labelText: "Phone Number",
                        ),
                        const SizedBox(
                          height: 20,
                        ),



                        //password input
                        _buildTextFieldPassword(
                          // hintText: 'Password',
                          obscureText: true,
                          prefixedIcon:
                          GradientIcon(
                            Icons.lock,
                            26,
                            const LinearGradient(
                              colors: <Color>[
                                Colors.awsStartColor,
                                Colors.awsStartColor,
                                Colors.awsEndColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          )
                          ,
                          labelText: "Password",
                        ),

                        const SizedBox(
                          height: 40,
                        ),
                        _buildLoginButton(),
                        const SizedBox(
                          height: 20,
                        ),

                        InkWell(
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontFamily: 'PT-Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.awsMixedColor,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPasswordScreen()));
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        _buildSignUpQuestion(),
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

          ,
        ),
      ),
    );
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState changed: $state");
    if (state == AppLifecycleState.resumed) {
      _showToast("resumed");
    }
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
        cursorColor: Colors.awsCursorColor,
        cursorWidth: 1.5,
        maxLength: 13,
        controller: phoneNumberController,
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

  Widget _buildTextFieldPassword({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Material(
      color: Colors.transparent,
      child: TextField(
        controller: passwordController,
        cursorColor: Colors.awsCursorColor,
        cursorWidth: 1.5,

        obscureText: _isObscure,
        // obscuringCharacter: "*",
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          // border: InputBorder.none,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          // labelText: 'Password',
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
              color: Colors.awsColor,
              icon: GradientIcon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
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

             // Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              }),

          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),

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
        ),
      ),
    );
  }


  Widget _buildLoginButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomeForTeacherScreen()));
          return;
          String phoneTxt = phoneNumberController!.text;
          String passwordTxt = passwordController!.text;
          if (_inputValid(phoneTxt, passwordTxt) == false) {
            //_showToast("call login user");
           // _logInUser(phoneTxt, passwordTxt);

           // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeScreen()));


          }else {

          }
          //Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
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
          child:  Text(
            "Login",
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

  Widget _buildSignUpQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an Account? ",
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        InkWell(
          child: const Text(
            'Sing Up',
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.awsColor,
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChooseRoleScreen()));
          },
        ),
      ],
    );
  }

  // Widget _buildTextFieldOTPView({
  //   required bool obscureText,
  //   Widget? prefixedIcon,
  //   String? hintText,
  //   String? labelText,
  // }) {
  //   return Container(
  //     color: Colors.transparent,
  //     child: OTPTextField(
  //       length: 6,
  //       width: MediaQuery.of(context).size.width,
  //       textFieldAlignment: MainAxisAlignment.spaceAround,
  //       fieldStyle: FieldStyle.underline,
  //       style: TextStyle(
  //         fontSize: 18,
  //         color: Colors.green,
  //       ),
  //       keyboardType: TextInputType.number,
  //       onCompleted: (pin) {
  //         _otpTxt = pin;
  //       },
  //       onChanged: (value) {
  //         if (value.length < 6) {
  //           _otpTxt = "";
  //         }
  //       },
  //     ),
  //   );
  // }

  Widget _buildVerifyButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.appRed,
          ),
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        ),
        child: const Text(
          'VERIFY',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          String s = otpEditTextController!.text;
          print(s);

          if (_otpTxt.isNotEmpty) {
            // _showToast(_otpTxt);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => NavigationBarScreen(0,HomePageScreen())));
          } else if (_otpTxt.length < 6) {
            _showToast("Please input 6 digit Number");
          } else {
            _showToast("Please input valid otp");
          }

          // Navigator.push(context,MaterialPageRoute(builder: (context)=>VerificationScreen()));
        },
      ),
    );
  }

  Widget _buildVerifyQuestion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "After 240 second",
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
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
            'Resend Code',
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          onTap: () {
            // Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
          },
        ),
      ],
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


