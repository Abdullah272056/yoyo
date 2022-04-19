import 'dart:convert';

import 'dart:io';

import 'package:aws_exam_portal/api%20service/NoDataFound.dart';
import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:aws_exam_portal/class_room_details/teacher_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CreateShortQuestionScreen extends StatefulWidget {
  String quiz_id;
  String classRoomName;


  CreateShortQuestionScreen(this.quiz_id, this.classRoomName);

  @override
  State<CreateShortQuestionScreen> createState() => _CreateShortQuestionScreenState(this.quiz_id,this.classRoomName);

}

class _CreateShortQuestionScreenState extends State<CreateShortQuestionScreen> {

  String _quiz_id;
  String _classRoomName;


  _CreateShortQuestionScreenState(this._quiz_id, this._classRoomName);

  TextEditingController? _shortQuestionNameController = TextEditingController();
  TextEditingController? _classRoomNameUpdateController =
      TextEditingController();
  bool _isObscure = true;

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";

  bool shimmerStatus = true;

  List teacherIndividualClassRoomQuizList = [];
  var teacherIndividualClassRoomQuizListResponse;

  @override
  @mustCallSuper
  initState() {
    super.initState();
    // _getTeacherRoomDataList();
    loadUserIdFromSharePref().then((_) {
      // _getTeacherIndividualClassroomQuizList(_classRoomId,_accessToken);
    });
    //loadUserIdFromSharePref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.backGroundColor,
        appBar: AppBar(
            leading: IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            title: Text(
              "Create Written Question",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Colors.awsEndColor, Colors.awsStartColor],
                ),
              ),
            )),
        body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.purple,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));

              //updateDataAfterRefresh();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ).copyWith(top: 5, bottom: 10),
              child:Flex(
                direction: Axis.vertical,
                children: [
                  SizedBox(height: 20,),
                  Expanded(child: _buildTextField()),
                  _buildSaveButton(),
                  SizedBox(height: 15,)

                ],
              ),

            )),
      ),
    );
  }

  Widget _buildTextField({
    String? hintText,
    String? labelText,
  }) {
    return TextFormField(
      controller: _shortQuestionNameController,
      minLines: 5,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: 'Enter your question',
          hintStyle: TextStyle(
              color: Colors.grey
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {

        String shortQuestionTxt = _shortQuestionNameController!.text;

        if (shortQuestionTxt.isEmpty) {
          Fluttertoast.cancel();
          _showToast("question can't empty");
          return;
        }

        _createShortQuestion(shortQuestionTxt);
        ///////////
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.awsStartColor, Colors.awsEndColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(7.0)),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Save",
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

  _createShortQuestion(String question ) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _showLoadingDialog(context,"Checking...");
        try {
          Response response = await post(
              Uri.parse('$BASE_URL_API$SUB_URL_API_CREATE_SHORT_QUESTION'),
              headers: {
                "Authorization": "Token $_accessToken",
              },
              body: {'question_name': question,
                "is_short_questions":"true",
                'teacher_id':_userId,
                'quiz_id':_quiz_id});

          if (response.statusCode == 201){

            Navigator.of(context).pop();
            _showToast("Success");
            Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateQuestionTeacherScreen(_quiz_id,_classRoomName)));

            var data = jsonDecode(response.body);

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
          _showToast("failed১");
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
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
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        const CircularProgressIndicator(
                          backgroundColor: Colors.appRed,
                          strokeWidth: 5,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          message,
                          style: const TextStyle(fontSize: 20),
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
        backgroundColor: Colors.awsMixedColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_Id)!;
      _accessToken = sharedPreferences.getString(pref_user_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
    });
  }
}
