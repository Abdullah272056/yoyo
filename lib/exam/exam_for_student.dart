import 'dart:convert';

import 'dart:io';

import 'package:aws_exam_portal/api%20service/NoDataFound.dart';
import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:aws_exam_portal/teacher_question/create_mcq_question.dart';
import 'package:aws_exam_portal/teacher_question/create_short_question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


class CreateExamScreen extends StatefulWidget {
  String quizId;
  String classRoomName;


  CreateExamScreen(this.quizId,this.classRoomName);

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState(this.quizId,this.classRoomName);
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  String _quizId;
  String _classRoomName;
  _CreateExamScreenState(this._quizId,this._classRoomName);


  TextEditingController? _shortQuestionNameController = TextEditingController();

  bool _isObscure = true;

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  String _userUUId = "";
  String _accessToken = "";
  String _refreshToken = "";

  bool shimmerStatus = true;
  String questionType = "";

  List questionList = [];
  List optionList = [];
  var questionResponse;

  int selectedValue = -1;

  String selected_question_mcq_options_id ="";

  @override
  @mustCallSuper
  initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {
      _getQuestionList(_accessToken);
    });

  }

  @override
  Widget build(BuildContext context)  {
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
            title:  Text(
              _classRoomName,
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
          child: Flex(
            direction: Axis.vertical,
            children: [
              if (shimmerStatus) ...[
                Expanded(
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        _buildExploreCityListShimmer(),
                      ],
                    ))
              ] else ...[
               Flex(direction: Axis.horizontal,

                  children: [
                    Expanded(child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Text((questionResponse["questions_answer_submitted"].toString()),
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 23,
                                fontWeight: FontWeight.w700)),
                        Text((" / "+questionResponse["total_questions"].toString()),
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 23,
                                fontWeight: FontWeight.w700)),

                      ],
                    )),
                    Expanded(child: Flex(
                      direction: Axis.horizontal,
                      children: [
                      ],
                    )),



                  ],
               ),
                if (questionList.length > 0) ...[
                      if(questionType=="1")...{
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 00),
                          child: Flex(direction: Axis.horizontal,
                            children: [
                              Text(("Q: "+questionList[0]["question_name"].toString()),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),

                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                            child:Flex(
                              direction: Axis.vertical,
                              children: [

                                Expanded(child: Container(
                                  color: Colors.transparent,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.appRed,
                                    ),
                                    child: Column(
                                      children: [

                                        ListView.builder(
                                          itemCount: optionList == null ? 0 : optionList.length,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return RadioListTile<int>(
                                                value: index,
                                                activeColor: Colors.appRed,
                                                title: Text(
                                                  optionList[index]["mcq_option_answer"].toString(),
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                                groupValue: selectedValue,
                                                onChanged: (value) => setState(() {
                                                  selectedValue = index;
                                                  // selected_question_mcq_options_id=optionList[index]["question_mcq_options_id"];
                                                })
                                            );
                                          },
                                        ),


                                      ],
                                    ),
                                  ),
                                ),),
                                _buildNextButton_mcq_question(questionList[0]["question_id"].toString()),

                                SizedBox(height: 15,)

                              ],
                            ),

                          ),
                        )
                      }
                      else if(questionType=="2")...{
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 00),
                          child: Flex(direction: Axis.horizontal,
                            children: [
                              Text(("Q: "+questionList[0]["question_name"].toString()),
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),

                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                            child:Flex(
                              direction: Axis.vertical,
                              children: [

                                Expanded(child: _buildShortQuestionAnswerTextField()),
                                _buildNextButton_short_question(questionList[0]["question_id"].toString()),

                                SizedBox(height: 15,)

                              ],
                            ),

                          ),
                        )
                      }
                      else...{
                          Expanded(
                            child: NoDataFound().noItemFound("Question Not Found! try again! "),
                          ),
                        }

                ] else ...[
                  Expanded(
                    child: NoDataFound().noItemFound("Question Not Found!"),
                  ),
                ],
              ]
            ],
          ),
        ),

      ),
    );
  }


  Widget _buildExploreCityListShimmer() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ListView(
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: ListView.builder(
                        itemCount: 16,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child: Container(
                                // width: 160,
                                height: 140,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Stack(children: <Widget>[
                                        Shimmer.fromColors(
                                          baseColor: Colors.shimmer_baseColor,
                                          highlightColor:
                                          Colors.shimmer_highlightColor,
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            color: Colors.black.withOpacity(0.3),
                                          ),
                                        ),
                                      ]),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          }),
      flex: 1,
    );
  }


  _getQuestionList(String accessToken) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        shimmerStatus = true;
        try {
          var response = await put(
            Uri.parse('$BASE_URL_API$SUB_URL_API_STUDENT_GET_QUESTION_LIST$_userUUId/'),
            headers: {
              "Authorization": "Token $accessToken",
            },
            body:{
              "quiz_id": "$_quizId",
            }
          );
         // _showToast(response.statusCode.toString());
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            questionResponse = jsonDecode(response.body);
            questionList=data["data"];
            optionList=data["data"][0]["questions_options"];
            shimmerStatus = false;
            if(data["data"][0]["is_mcq_questions"].toString()=="true"){
              questionType="1";

            }else{
              questionType="2";
            }
              setState(() {

              });

          }
          else {
            Fluttertoast.cancel();
            _showToast("Failed");
          }
        } catch (e) {
          Fluttertoast.cancel();
          print(e.toString());
          _showToast("Failed2");
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.cancel();
      _showToast("No Internet Connection!");
    }
  }


  Widget _buildShortQuestionAnswerTextField({
    String? hintText,
    String? labelText,
  }) {
    return TextFormField(
      controller: _shortQuestionNameController,
      minLines: 5,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: 'Write your answer',
          hintStyle: TextStyle(
              color: Colors.grey
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
      ),
    );
  }

  Widget _buildNextButton_short_question(String questionId) {
    return ElevatedButton(
      onPressed: () {

        String shortQuestionAnswerTxt = _shortQuestionNameController!.text;

        if (shortQuestionAnswerTxt.isEmpty) {
          Fluttertoast.cancel();
          _showToast("Answer can't empty");
          return;
        }


        _submitShortQuestion(shortQuestionAnswerTxt,questionId);
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
            "Submit Short",
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
  Widget _buildNextButton_mcq_question(String questionId) {
    return ElevatedButton(
      onPressed: () {

        if (selectedValue==-1) {
          Fluttertoast.cancel();
          _showToast("please select answer! ");
          return;
        }else{
          selected_question_mcq_options_id=optionList[selectedValue]["question_mcq_options_id"].toString();
          _submitMCQQuestion(selected_question_mcq_options_id,questionId);
          _showToast(selected_question_mcq_options_id);
        }



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
            "Submit Mcq",
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

  _submitShortQuestion(String answer,questionId ) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _showLoadingDialog(context,"Checking...");
        try {
          Response response = await post(
              Uri.parse('$BASE_URL_API$SUB_URL_API_STUDENT_SHORT_QUESTION_ANSWER_SUBMIT'),
              headers: {
                "Authorization": "Token $_accessToken",
              },
              body: {
                'student_id': _userId,
                "quiz_id":_quizId,
                'question_id':questionId,
                'student_answer':answer});

          if (response.statusCode == 200){

              setState(() {
                Navigator.of(context).pop();
                _showToast("Success");
                _getQuestionList(_accessToken);
              });


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
  _submitMCQQuestion(String answer,questionId ) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _showLoadingDialog(context,"Checking...");
        try {
          Response response = await post(
              Uri.parse('$BASE_URL_API$SUB_URL_API_STUDENT_MCQ_QUESTION_ANSWER_SUBMIT'),
              headers: {
                "Authorization": "Token $_accessToken",
              },
              body: {
                'student_id': _userId,
                "quiz_id":_quizId,
                'question_id':questionId,
                'question_mcq_options_id':answer
              });

          if (response.statusCode == 200){
              setState(() {
                Navigator.of(context).pop();
                _showToast("Success");
                _getQuestionList(_accessToken);

              });


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

  // void updateDataAfterRefresh() {
  //   _getTeacherIndividualClassroomQuizList(_classRoomId,_accessToken);
  //   setState(() {});
  // }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_Id)!;
      _accessToken = sharedPreferences.getString(pref_user_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;
      _userUUId = sharedPreferences.getString(pref_user_UUID)!;

    });
  }

}
