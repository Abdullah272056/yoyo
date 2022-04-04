
import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeForTeacherScreen extends StatefulWidget {
  const HomeForTeacherScreen({Key? key}) : super(key: key);
  @override
  State<HomeForTeacherScreen> createState() => _HomeForTeacherScreenState();
}

class _HomeForTeacherScreenState extends State<HomeForTeacherScreen> {
  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;



  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  bool shimmerStatus=true;
  List teacherRoomList=[];
  var teacherRoomListResponse;

  @override
  @mustCallSuper
  initState() {
    super.initState();
   // _getTeacherRoomDataList();
    loadUserIdFromSharePref().then((_) {

      _getTeacherRoomDataList(_userId);
    });
    //loadUserIdFromSharePref();
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
              ).copyWith(top: 20),
              child: Column(
                children: [
                  Text("Home Page for teacher"),
                ],
              ),
            ),
          )

          ,
        ),
      ),
    );
  }


  _getTeacherRoomDataList(String u_id) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        shimmerStatus=true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_TEACHERS_ALL_CLASS_ROOM_LIST$u_id/'),
          );

          if (response.statusCode == 200) {
            setState(() {
              //_showToast("success");
              var data = jsonDecode(response.body);
              teacherRoomList = data["data"];
              _showToast(teacherRoomList.length.toString());
              shimmerStatus=false;
            });
          } else {
            Fluttertoast.cancel();
            //_showToast("Failed");
          }
        } catch (e) {
          Fluttertoast.cancel();
          print(e.toString());
          //_showToast("Failed");
        }
      }
    } on SocketException catch (e) {
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

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if(sharedPreferences.getString(pref_user_Id)!=null){
        _userId = sharedPreferences.getString(pref_user_Id)!;
      }else{
        _userId="30";
      }

    });
  }
}


