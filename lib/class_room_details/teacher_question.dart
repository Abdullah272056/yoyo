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


class CreateQuizTeacherScreen extends StatefulWidget {
  String quizId;
  String classRoomName;


  CreateQuizTeacherScreen(this.quizId,this.classRoomName);

  @override
  State<CreateQuizTeacherScreen> createState() => _CreateQuizTeacherScreenState(this.quizId,this.classRoomName);
}

class _CreateQuizTeacherScreenState extends State<CreateQuizTeacherScreen> {
  String _quizId;
  String _classRoomName;
  _CreateQuizTeacherScreenState(this._quizId,this._classRoomName);

  TextEditingController? _qiuizNameController = TextEditingController();
  TextEditingController? _classRoomNameUpdateController = TextEditingController();

  bool _isObscure = true;

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";

  bool shimmerStatus = true;

  List questionList = [];
  var questionListResponse;

  @override
  @mustCallSuper
  initState() {
    super.initState();

    loadUserIdFromSharePref().then((_) {
      _getAllQuestionList(_accessToken);
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
                if (questionList != null &&
                    questionList.length > 0) ...[
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ).copyWith(top: 5, bottom: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: _buildQuestionList(),
                              flex: 1,
                            ),
                          ],
                        )),
                  )
                ] else ...[
                  Expanded(
                    child: NoDataFound().noItemFound("Class Room Not Found!"),
                  ),
                ],
              ]
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _qiuizNameController?.clear();

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0)), //this right here
                    child: Wrap(

                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 0,bottom: 10,top: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flex(direction: Axis.horizontal,
                                children: [
                                  Expanded(child: Text("Create Question"),),
                                  IconButton(
                                    icon: const Icon(Icons.cancel),
                                    color: Colors.deepOrange,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),

                              SizedBox(height: 30,),
                              InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateMCQQuestionScreen(_quizId,_classRoomName)));
                                },
                                child: const Center(
                                  child: Text(
                                    "Create MCQ Question",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.black87,fontSize: 18,),
                                  ),
                                ),

                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5.0, right: 5.0,top: 12,bottom: 12),
                                height: 1.0,
                                color: Colors.black87,
                              ),
                              InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateShortQuestionScreen(_quizId,_classRoomName)));

                                },
                                child: const Center(
                                  child: Text(
                                    "Short/Description Question",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.black87,fontSize: 18,),
                                  ),
                                ),

                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5.0, right: 5.0,top: 12,bottom: 12),
                                height: 1.0,
                                color: Colors.black87,
                              ),


                            ],
                          ),
                        )
                      ],
                    ),
                  );
                });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }


  Widget _buildQuestionList() {
    return ListView.builder(
        itemCount:
        questionList == null ? 0 : questionList.length,

        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Wrap(
                  children: [
                    Container(

                      padding: EdgeInsets.all(15.0),
                      child: Column(

                        children: [
                          Flex(direction: Axis.horizontal,
                            children: [
                              Text((index+1).toString()+". "+ questionList[index]["question_name"].toString(),
                                  style: TextStyle(
                                      color: Colors.awsEndColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),



                          if(questionList[index]["is_mcq_questions"])...[
                            for(int i=0; i<questionList[index]["questions_options"].length;i++)...{
                              SizedBox(height: 4,),
                              if(questionList[index]["questions_options"][i]["is_correct_answer"])...[
                                Flex(direction: Axis.horizontal,children: [
                                  Icon(
                                    Icons.verified_user,
                                    color: Colors.green,
                                    size: 20.0,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(questionList[index]["questions_options"][i]["mcq_option_answer"].toString())
                                ],)

                              ]
                              else...[
                                Flex(direction: Axis.horizontal,children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.deepOrange,
                                    size: 20.0,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(questionList[index]["questions_options"][i]["mcq_option_answer"].toString())
                                ],)
                              ]

                            }


                          ]



                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            onTap: () {
             //  _showToast("Clicked Item $index");

            },
          );
        });
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


  _getAllQuestionList(String accessToken) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        shimmerStatus = true;
        try {
          var response = await get(
            Uri.parse('$BASE_URL_API$SUB_URL_API_QUESTION_LIST$_quizId/'),
            headers: {
              "Authorization": "Token $accessToken",
            },
          );
          if (response.statusCode == 200) {
            _showToast("Success");
            setState(() {
              var data = jsonDecode(response.body);
              questionList = data["data"];
              //_showToast(teacherClassRoomList.length.toString());
              shimmerStatus = false;
            });
          }
          else {
            Fluttertoast.cancel();
            _showToast("Failed");
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

    });
  }

}
