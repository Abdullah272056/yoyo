import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:aws_exam_portal/background/background.dart';
import 'package:aws_exam_portal/home_page/home_page_for_student.dart';
import 'package:aws_exam_portal/home_page/home_page_for_teacher.dart';
import 'package:aws_exam_portal/home_page/profile/profile_page.dart';
import 'package:aws_exam_portal/registration/sign_up_page_as_teacher.dart';
import 'package:aws_exam_portal/registration/user_active_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gradiant_icon.dart';
import 'VerificationAfterRegistration.dart';
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

          String phoneTxt = phoneNumberController!.text;
          String passwordTxt = passwordController!.text;
          if (_inputValid(phoneTxt, passwordTxt) == false) {
           _logInUser(phoneTxt, passwordTxt);

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


  _logInUser(String mobile, String password) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _showLoadingDialog(context,"Checking...");
        try {
          Response response = await post(Uri.parse('$BASE_URL_API$SUB_URL_API_SIGN_IN'),
              body: {'phone_number': mobile, 'password': password});

          if (response.statusCode == 200) {
            Navigator.of(context).pop();
            setState(() {
              var data = jsonDecode(response.body.toString());
             saveUserInfo(data);
              if(data['data']["is_teacher"]==true){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomeForTeacherScreen()));

                // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeForStudentScreen()));
              }else{
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeForStudentScreen()));

              }


            });
          }
          else if (response.statusCode == 201){

            var data = jsonDecode(response.body);
            _reSendCode( user_id: data['data']["id"].toString());

          }
          else if (response.statusCode == 400) {
            Navigator.of(context).pop();
            var data = jsonDecode(response.body.toString());
            Fluttertoast.cancel();
            //  _showToast(data['message'].toString());
            _showToast("phone or password not match!");
          }
          else {
            Navigator.of(context).pop();
            var data = jsonDecode(response.body.toString());
            Fluttertoast.cancel();
            _showToast(data['message'].toString());
          }
        } catch (e) {
          Navigator.of(context).pop();
          Fluttertoast.cancel();
          print(e.toString());
          _showToast("failed");
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }
  _reSendCode({required String user_id}) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        //_showLoadingDialog(context,"Sending...");
        try {
          Response response = await put(
            Uri.parse('$BASE_URL_API$SUB_URL_API_RESEND_CODE$user_id/'),
          );
          Navigator.of(context).pop();

          if (response.statusCode == 200) {
            _showToast("Check your email!");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerificationAfterSignUpScreen(user_id)));

          } else {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
          }
        } catch (e) {
          print(e.toString());
        }
      }
    } on SocketException catch (_) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }
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


  void saveUserInfo(var userInfo) async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      sharedPreferences.setString(pref_user_token, userInfo['access_token'].toString());
      sharedPreferences.setString(pref_user_refresh_token, userInfo['refresh_token'].toString());
      // sharedPreferences.setBool(pref_login_status, true);
      sharedPreferences.setString(pref_user_Id, userInfo['data']["id"].toString());
      sharedPreferences.setString(pref_user_email, userInfo['data']["email"].toString());
      sharedPreferences.setString(pref_user_gender, userInfo['data']["gender"].toString());
      // sharedPreferences.setString(pref_user_dob, userInfo['data']["date_of_birth"].toString());
      sharedPreferences.setString(pref_user_short_address,userInfo['data']["user_short_address"].toString());
      // sharedPreferences.setString(pref_user_image, userInfo['data']["user_image"].toString());
      sharedPreferences.setString(pref_user_name, userInfo['data']["username"].toString());
      sharedPreferences.setString(pref_user_number, userInfo['data']["phone_number"].toString());

      //sharedPreferences.setString(pref_user_city_id, userInfo['data']["city_id"].toString());

      sharedPreferences.setString(pref_user_Is_Teacher, userInfo['data']["is_teacher"].toString());
      sharedPreferences.setString(pref_user_Is_Student, userInfo['data']["is_student"].toString());
      sharedPreferences.setString(pref_user_UUID, userInfo['data']["uid"].toString());


    } catch (e) {
      //code
    }

    //
    // sharedPreferences.setString(pref_user_UUID, userInfo['data']["user_name"].toString());
    // sharedPreferences.setBool(pref_login_firstTime, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_cartID, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_county, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_city, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_state, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_nid, userInfo['data']["user_name"].toString());
    // sharedPreferences.setString(pref_user_nid, userInfo['data']["user_name"].toString());
  }

  void removeUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(pref_user_token, "");
    sharedPreferences.setString(pref_user_refresh_token, "");
    sharedPreferences.setBool(pref_login_status, false);
    sharedPreferences.setString(pref_user_Id, "");
    sharedPreferences.setString(pref_user_email, "");
    sharedPreferences.setString(pref_user_gender, "");
    sharedPreferences.setString(pref_user_dob, "");
    sharedPreferences.setString(pref_user_short_address, "");
    sharedPreferences.setString(pref_user_image, "");
    sharedPreferences.setString(pref_user_name, "");
    sharedPreferences.setString(pref_user_number, "");
    sharedPreferences.setString(pref_user_city_id, "");

  }

  void _showLoadingDialog(BuildContext context,String message){
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
                      children:  [
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
                          message,
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


