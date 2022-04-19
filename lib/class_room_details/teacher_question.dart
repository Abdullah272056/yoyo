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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CreateQuestionTeacherScreen extends StatefulWidget {
  String quizId;
  String classRoomName;

  CreateQuestionTeacherScreen(this.quizId,this.classRoomName);

  @override
  State<CreateQuestionTeacherScreen> createState() => _CreateQuestionTeacherScreenState(this.quizId,this.classRoomName);
}

class _CreateQuestionTeacherScreenState extends State<CreateQuestionTeacherScreen> {
  String _quizId;
  String _classRoomName;
  _CreateQuestionTeacherScreenState(this._quizId,this._classRoomName);

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



  final _dateOfBirthValue = "--------";
  final _dateOfBirthValueForBooking = "--------";
  late DateTime _myStartDate, _myEndDate;
  late TimeOfDay _mySelectedTime;
  TimeOfDay selectedTime = TimeOfDay.now();
  late TimeOfDay timeOfDay;
  late DateTime _myStartDateForBooking, _myEndDateForBooking;
  String _startDate = "select date";
  String _selectedTimeText = "select time";

  String _startDateForBooking = "select date";



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
                Flex(direction: Axis.horizontal,
                  children: [
                    Expanded(child:
                    Flex(

                      direction: Axis.vertical,
                      children: [
                        Text("Date: "+"2022-04-18",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                        Text("Time: "+"12:00",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                        Text("Quiz Duration: "+"80 minute",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),),
                    _buildCreateQuizTime()

                  ],

                ),

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
                    child: NoDataFound().noItemFound("Question Not Found!"),
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

  Widget _buildCreateQuizTime() {
    return InkWell(
      child: Flex(

        direction: Axis.horizontal,
        children: [
          Text("Create\nQuiz",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 23,
                  fontWeight: FontWeight.w700)),
        ],
      ),
      onTap: (){
        _startDate = "select date";
        _selectedTimeText = "select time";

        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: 370,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 5, right: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            // child: Icon(Icons.arrow_drop_down_sharp,size: 40,),
                            child: InkWell(
                              child: Image.asset(
                                "assets/images/drop_down.png",
                                width: 40,
                                height: 20,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Please Select Date",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 12,
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Quiz Start Date",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          //cvbnm,
                          _buildStartDate(
                              fieldName: "Choose date",
                              fieldValue: _dateOfBirthValue),



                          SizedBox(
                            height: 15,
                          ),
                          _buildStartTime(fieldName: "Choose time",
                              fieldValue: _dateOfBirthValue),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.awsMixedColor,
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
                                'Create',
                                style: TextStyle(
                                  fontFamily: 'PT-Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                //_showToast("clicked");
                                setState(() {
                                  // DateTime dt1 = DateTime.parse("2021-12-23 11:47:00");
                                  // DateTime dt2 = DateTime.parse("2018-09-12 10:57:00");
                                  //
                                  // Duration diff = dt1.difference(dt2);
                                  // print(diff.inDays);

                                  // DateTime dt_start = DateTime.parse(_startDate);
                                  //
                                  // Duration diff = dt_end.difference(dt_start);
                                  //
                                  // if (diff.inDays > 0) {
                                  //   //call get user cart id
                                  //   _showToast("ok");
                                  // } else if (diff.inDays <= 0) {
                                  //   _showToast(
                                  //       "please select correct date format");
                                  // } else {
                                  //   _showToast("please select date");
                                  // }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
          ),
        );
      },
    );
  }
//start date
  Widget _buildStartDate({
    required String fieldName,
    required String fieldValue,
  }) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _startDate,
                        style: const TextStyle(
                          fontFamily: 'PT-Sans',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () async {
              _myStartDate = (await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,
                    DateTime.now().day),
                // lastDate: DateTime(2300),
              ))!;
              _startDate = _myStartDate.toString();
              _startDate = DateFormat('yyyy-MM-dd').format(_myStartDate);
              setState(() {});
            },
          );
        });
  }

  Widget _buildStartTime({
    required String fieldName,
    required String fieldValue,
  }) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedTimeText,
                        style: const TextStyle(
                          fontFamily: 'PT-Sans',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () async {
              timeOfDay = (await
              showTimePicker(
                context: context,
                initialTime: selectedTime,
                initialEntryMode: TimePickerEntryMode.input,
                confirmText: "CONFIRM",
                cancelText: "NOT NOW",
                helpText: "Quiz TIME",
              ))!;
              _selectedTimeText="${timeOfDay.hour}:${timeOfDay.minute}:00";;
              //_startDate = DateFormat('yyyy-MM-dd').format(selectedTime);
              setState(() {

              });
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
