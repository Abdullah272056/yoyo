import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:aws_exam_portal/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart';


class SendUserForActiveScreen extends StatefulWidget {
  String userId;

  SendUserForActiveScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<SendUserForActiveScreen> createState() => _SendUserForActiveScreenState(this.userId);
}

class _SendUserForActiveScreenState extends State<SendUserForActiveScreen> {
  String userId;
  _SendUserForActiveScreenState(this.userId);

  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;



  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";

  // late OTPCountDown _otpCountDown; // create instance
  // final int _otpTimeInMS = 1000 * 4 * 60;
  // int _otpTimeInMS = 1000 * 15;
  bool _isCountingStatus=false;
  String _time="4:00";
  late Timer _timer;
  int _start = 4 * 60;


  @override
  @mustCallSuper
  void initState() {
    super.initState();
    _readValue();
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 60),
              child: Column(
                children: [
                  _buildTextFieldPhone(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  _readValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //prefs.getString("named")??"Empty";
      if (prefs.getString("named") != null) {
        // passwordController=TextEditingController(text:prefs.getString("named"));
      } else {}
    });
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
                  "assets/images/porzotok.png",
                  width: 120,
                  height: 65,
                )
              ],
            ),
          ),
          // Image.asset('assets/images/profile.jpg'),
          const Text(
            "let's Discover Bangladesh Together",
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          // Image.asset('assets/images/profile.jpg'),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Verification code has been send to your mobile",
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
        // textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.underline,
        style: TextStyle(
          fontSize: 18,
          color: Colors.green,

        ),
        keyboardType: TextInputType.number,
        onCompleted: (otp) {
          _otpTxt = otp;
        },
        onChanged: (value) {
          if (value.length < 6) {
            _otpTxt = "";
          }
        },
      ),
    );
  }
  _reSendCode(userId) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _showLoadingDialog(context,"Sending...");
        try {
          Response response = await put(Uri.parse('$BASE_URL_API$SUB_URL_API_RESEND_CODE$userId/'),);

          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            _showToast("Check your message");
            _isCountingStatus=true;
            startTimer();
           // countDown();
            setState(() {

            });
          }
          else {
            var data = jsonDecode(response.body.toString());
            Fluttertoast.cancel();
            _showToast(data['message'].toString());
          }
        } catch (e) {
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
          Response response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_VERIFICATION_AFTER_REGISTRATION?user_id=$userId&code=$otp_code'),
          );
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body.toString());
            saveUserInfo(data);

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,);

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
         // _showToast(userId);

          // String s = otpEditTextController!.text;
          // print(s);

          if (_otpTxt.isEmpty) {
            _showToast("Please input 6 digit Number");
          } else if (_otpTxt.length < 6) {
            _showToast("Please input 6 digit Number");
          } else {
           // _showToast(_otpTxt);
            _verifyAfterSignUp(otp_code: _otpTxt,user_id: userId);
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

        if(_isCountingStatus==true)...[
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
        else if(_isCountingStatus==false)...[
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
              _reSendCode(userId);
              // Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
            },
          ),
        ],



      ],
    );
  }
  // countDown1(){
  //   _otpCountDown = OTPCountDown.startOTPTimer(
  //     timeInMS: _otpTimeInMS, // time in milliseconds
  //
  //     currentCountDown: (String countDown) {
  //       //print("Count down : $countDown");
  //       setState(() {
  //         _time=countDown.toString();
  //       });
  //       // shows current count down time
  //     },
  //     onFinish: () {
  //       setState(() {
  //         _isCountingStatus=false;
  //       });
  //       // print("Count down finished!"); // called when the count down finishes.
  //     },
  //   );
  // }
  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start<= 0) {
          setState(() {
            _isCountingStatus=false;
            timer.cancel();

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

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showLoadingDialog(BuildContext context,String textMessage) {
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
                          textMessage,
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
}
