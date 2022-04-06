import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:aws_exam_portal/background/background.dart';
import 'package:aws_exam_portal/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VerificationAfterSignUpScreen extends StatefulWidget {
  final String userId;

  const VerificationAfterSignUpScreen(this.userId, {Key? key})
      : super(key: key);

  @override
  State<VerificationAfterSignUpScreen> createState() =>
      _VerificationAfterSignUpScreenState(this.userId);
}

class _VerificationAfterSignUpScreenState
    extends State<VerificationAfterSignUpScreen> {
  late String userId;
  _VerificationAfterSignUpScreenState(this.userId);

  TextEditingController? _otpCodeController = TextEditingController();

  String _otpTxt = "";

  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;


  TextEditingController? otpEditTextController = new TextEditingController();


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
                        horizontal: 20,
                      ).copyWith(top: 20),
                      child: Column(
                        children: [
                          _buildTextFieldPhone(),
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



  Widget _buildTextFieldPhone() {
    return Container(
      margin: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 20, bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 00,
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/aws.png",
                  width: 120,
                  height: 65,
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
            height: 20,
          ),
          const Text(
            "Verification code has been send to your email",
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 30,
          ),

          //phone number input
          _buildTextFieldOTPView(
            hintText: 'Enter 6 digit Number',
            obscureText: false,
            prefixedIcon:
            const Icon(Icons.phone, color: Colors.appRed),
          ),
          const SizedBox(
            height: 30,
          ),

          _buildVerifyButton(),

          const SizedBox(
            height: 20,
          ),
          _buildVerifyQuestion(),
        ],
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

  Widget _buildVerifyButton() {
    return ElevatedButton(
      onPressed: () {
        if (_otpTxt.isNotEmpty) {
          _verifyAfterSignUp(user_id: userId, otp_code: _otpTxt);
        } else if (_otpTxt.length < 6) {
          _showToast("Please input 6 digit Number");
        } else {
          _showToast("Please input valid otp");
        }
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
            style: const TextStyle(
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
              'Resend Code',
              style: TextStyle(
                fontFamily: 'PT-Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            onTap: () {
              _reSendCode( user_id: userId);
              // Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
            },
          ),
        ],



      ],
    );
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

  _verifyAfterSignUp({
    required String user_id,
    required String otp_code,
  }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _showLoadingDialog(context,"Verifying...");
        try {
          Response response = await post(
            Uri.parse('$BASE_URL_API$SUB_URL_API_VERIFICATION_AFTER_REGISTRATION'),
              body: {
                'user_id': user_id,
                'code': otp_code,
              }
          );
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            _showToast("success");
            // var data=jsonDecode(response.body.toString());

            var data = jsonDecode(response.body.toString());
           saveUserInfo(data);
            //////////
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeScreen()));

          } else if (response.statusCode == 400) {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
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
  _reSendCode({required String user_id}) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _showLoadingDialog(context,"Sending...");
        try {
          Response response = await put(
            Uri.parse('$BASE_URL_API$SUB_URL_API_RESEND_CODE$user_id/'),
          );
          Navigator.of(context).pop();

          if (response.statusCode == 200) {
            _showToast("Check your email!");
            _isCountingStatus=false;
           // countDown();
            _start = 4 * 60;
            startTimer();
            setState(() {

            });
          } else if (response.statusCode == 400) {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
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

  void _showLoadingDialog(BuildContext context,String message) {
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
                      children:  [
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
                          message,
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
