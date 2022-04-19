import 'dart:convert';

import 'dart:io';

import 'package:aws_exam_portal/api%20service/NoDataFound.dart';
import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:aws_exam_portal/class_room_details/teacher_question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


class IndividualClassroomQuizTeacherScreen extends StatefulWidget {
  String classRoomId;
  String classRoomName;


  IndividualClassroomQuizTeacherScreen(this.classRoomId,this.classRoomName);

  @override
  State<IndividualClassroomQuizTeacherScreen> createState() => _IndividualClassroomQuizTeacherScreenState(this.classRoomId,this.classRoomName);
}

class _IndividualClassroomQuizTeacherScreenState extends State<IndividualClassroomQuizTeacherScreen> {
  String _classRoomId;
  String _classRoomName;
  _IndividualClassroomQuizTeacherScreenState(this._classRoomId,this._classRoomName);

  TextEditingController? _qiuizNameController = TextEditingController();
  TextEditingController? _classRoomNameUpdateController = TextEditingController();
  bool _isObscure = true;

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";

  late Color _quizButtonColor = Colors.green,
      _studentButtonColor = Colors.white;
  late Color _quizButtonTextColor = Colors.white,
      _studentButtonTextColor = Colors.black;

  late bool isListBtnClicked = false;
  int listMethodCode = 1;
  bool shimmerStatus = true;
  bool shimmerStatusStudent = true;

  List teacherIndividualClassRoomQuizList = [];
  List teacherIndividualClassRoomStudentList = [];
  var teacherIndividualClassRoomQuizListResponse;
  var teacherIndividualClassRoomStudentListResponse;

  @override
  @mustCallSuper
  initState() {
    super.initState();
    // _getTeacherRoomDataList();
    loadUserIdFromSharePref().then((_) {
      _getTeacherIndividualClassroomQuizList(_classRoomId,_accessToken);
      _getTeacherIndividualClassroomStudentList(_classRoomId,_accessToken);
    });
    //loadUserIdFromSharePref();
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
            actions: [
              Center(
                  child: InkResponse(
                    child: const Text(

                      "Create\nQuiz",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    onTap: (){
                      _qiuizNameController?.clear();
                      showModalBottomSheet<dynamic>(
                        backgroundColor: Colors.white,
                        isDismissible: true,
                        context: context,

                        isScrollControlled: true,
                        builder: (BuildContext context) {

                          return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return  Padding(
                                  padding:
                                  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  //const EdgeInsets.only(left: 15, top: 5, right: 10, bottom: 10),
                                  child:SingleChildScrollView(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(left: 15, top: 5, right: 10, bottom: 10),
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
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text(
                                            "Create New Quiz",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),

                                          _buildTextField(
                                              obscureText: false,
                                              labelText: "Quiz Name"),

                                          const SizedBox(
                                            height: 25,
                                          ),
                                          _buildRoomAddButton(),
                                          const SizedBox(
                                            height: 15,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                ;
                              });
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0)),
                        ),
                      );

                    },
                  )),
              const SizedBox(
                width: 20,
              )
            ],
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

            updateDataAfterRefresh();
          },
          child: Flex(
            direction: Axis.vertical,
            children: [
              _buildTabMethod(),
              if(listMethodCode==1)...[
                if (shimmerStatus) ...[


                  Expanded(
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          _buildShimmer(),
                        ],
                      )),


                ] else ...[
                  if (teacherIndividualClassRoomQuizList != null &&
                      teacherIndividualClassRoomQuizList.length > 0) ...[

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
                                child: _buildTeacherClassRoomList(),
                              ),
                            ],
                          )),
                    ),

                  ] else ...[

                    Expanded(
                      child: NoDataFound().noItemFound("Quiz Not Found!"),
                    ),
                  ],
                ],
              ]
              else if(listMethodCode==2)...[

                if (shimmerStatusStudent) ...[
                  Expanded(
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          _buildShimmer(),
                        ],
                      ))
                ] else ...[
                  if (teacherIndividualClassRoomStudentList != null &&
                      teacherIndividualClassRoomStudentList.length > 0) ...[
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
                                child: _buildStudentList(),
                                flex: 1,
                              ),
                            ],
                          )),
                    )

                  ] else ...[

                    Expanded(
                      child: NoDataFound().noItemFound("Student not found in this class!"),
                    ),
                  ],
                ],


              ]
              else ...[
                  if (shimmerStatus) ...[


                    Expanded(
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            _buildShimmer(),
                          ],
                        ))
                  ] else ...[
                    if (teacherIndividualClassRoomQuizList != null &&
                        teacherIndividualClassRoomQuizList.length > 0) ...[

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
                                  child: _buildTeacherClassRoomList(),
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
                  ],
                ]


            ],
          ),
        ),

      ),
    );
  }

  Widget _buildTextField({
    required bool obscureText,
    // Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Container(
      color: Colors.transparent,
      child: TextField(
        controller: _qiuizNameController,
        textInputAction: TextInputAction.next,
        cursorColor: Colors.awsCursorColor,
        cursorWidth: 1.5,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.hint_color,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          // prefixIcon: prefixedIcon,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsEndColor, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsStartColor, width: .2),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }



  Widget _buildRoomAddButton() {
    return SizedBox(
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
          String quizNameTxt = _qiuizNameController!.text;
          if (quizNameTxt.isEmpty) {
            _showToast("Class room name can't empty!");
            return;
          }
          Navigator.of(context).pop();
          _createQuizName(quizNameTxt,_userId);
          //_showToast(classRoomNameTxt);

        },
      ),
    );
  }


  Widget _buildTeacherClassRoomList() {
    return ListView.builder(
        itemCount:
        teacherIndividualClassRoomQuizList == null ? 0 : teacherIndividualClassRoomQuizList.length,

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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Quiz Title",
                              style: TextStyle(
                                color: Colors.awsEndColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                                teacherIndividualClassRoomQuizList[index]["quiz_title"]
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.awsEndColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),

                            SizedBox(height: 15,),

                            Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.awsEndColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                                teacherIndividualClassRoomQuizList[index]["date"]
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.awsEndColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700))


                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            onTap: () {
             //  _showToast("Clicked Item $index");
              Navigator.push(context,MaterialPageRoute(builder: (context)=> CreateQuestionTeacherScreen(
                  teacherIndividualClassRoomQuizList[index]["quiz_id"].toString(),
                  teacherIndividualClassRoomQuizList[index]["quiz_title"].toString())));
            },
          );
        });
  }

  Widget _buildStudentList() {
    return ListView.builder(
        itemCount:
        teacherIndividualClassRoomStudentList == null ? 0 : teacherIndividualClassRoomStudentList.length,

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
                      padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          Text(
                              "Student id: "+teacherIndividualClassRoomStudentList[index]["student_info"]["id"].toString(),
                              style: TextStyle(
                                  color: Colors.awsEndColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400)),

                          Text(
                              "Name: "+teacherIndividualClassRoomStudentList[index]["student_info"]["username"].toString(),
                              style: TextStyle(
                                  color: Colors.awsEndColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400)),
                          Text(
                              "Phone: "+teacherIndividualClassRoomStudentList[index]["student_info"]["phone_number"].toString(),
                              style: TextStyle(
                                  color: Colors.awsEndColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400)),
                          Text(
                              "Email: "+teacherIndividualClassRoomStudentList[index]["student_info"]["email"].toString(),
                              style: TextStyle(
                                  color: Colors.awsEndColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400)),

                          SizedBox(height: 5,),

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


  Widget _buildShimmer() {
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

  _getTeacherIndividualClassroomQuizList(String class_room_id,String accessToken) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        shimmerStatus = true;
        try {
          var response = await get(
            Uri.parse('$BASE_URL_API$SUB_URL_API_TEACHER_GET_INDIVIDUAL_CLASSROOM_QUIZ_LIST$class_room_id/'),
            headers: {
              "Authorization": "Token $accessToken",
            },
          );

          if (response.statusCode == 200) {
            setState(() {
              //_showToast("success");
              var data = jsonDecode(response.body);
              teacherIndividualClassRoomQuizList = data["data"];
              //_showToast(teacherClassRoomList.length.toString());
              shimmerStatus = false;
            });
          }
          else {
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

  _getTeacherIndividualClassroomStudentList(String class_room_id,String accessToken) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        shimmerStatusStudent = true;
        //_showToast("connected");
        try {
          var response = await get(
            Uri.parse('$BASE_URL_API$SUB_URL_API_TEACHER_GET_INDIVIDUAL_CLASSROOM_STUDENT_LIST$class_room_id/'),
            headers: {
              "Authorization": "Token $accessToken",
            },
          );
       // _showToast(response.statusCode.toString());
          if (response.statusCode==200) {
           // _showToast("success");
            shimmerStatusStudent = false;
            var data = jsonDecode(response.body);
            teacherIndividualClassRoomStudentList = data["data"]["student_list"];
            // setState(() {
            //
            // });
          }
          else {
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

  _createQuizName(String quizName,String u_id) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _showLoadingDialog(context,"Creating...");
        try {
          Response response = await post(
              Uri.parse('$BASE_URL_API$SUB_URL_API_TEACHER_QUIZ_CREATE'),
              headers: {
                "Authorization": "Token $_accessToken",
              },
              body: {
                'quiz_title': quizName,
                'teacher_id': u_id,
                'class_room_id': _classRoomId,

              });
          Navigator.of(context).pop();
          if (response.statusCode == 201) {


            _getTeacherIndividualClassroomQuizList(_classRoomId,_accessToken);
            setState(() {
              _showToast("success");
            });
          }
          else if (response.statusCode == 401) {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
          }
          else {
            var data = jsonDecode(response.body.toString());
            if(data['message']!=null){
              _showToast(data['message']);
            }
            else{
              _showToast("Failed try again!");
            }
          }
        } catch (e) {
          Navigator.of(context).pop();
          print(e.toString());
        }
      }
    } on SocketException catch (_) {
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

  void updateDataAfterRefresh() {
    _getTeacherIndividualClassroomQuizList(_classRoomId,_accessToken);
    setState(() {});
  }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_Id)!;
      _accessToken = sharedPreferences.getString(pref_user_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;

    });
  }

  Widget _buildTabMethod() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuizListButton(_quizButtonColor,_quizButtonTextColor),
            ],
          ),
          flex: 1,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStudentListButton(_studentButtonColor,_studentButtonTextColor),
            ],
          ),
          flex: 1,
        ),
      ],
    );
  }
  Widget _buildQuizListButton(Color bgcolor,Color txtColor) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            bgcolor,
          ),
          elevation: MaterialStateProperty.all(3),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5))),
          ),
        ),
        child:  Text(
          "Quiz list",
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color:txtColor,
          ),
        ),
        onPressed: () {
          setState(() {
            isListBtnClicked = true;
            listMethodCode = 1;
            _quizButtonColor = Colors.green;
            _studentButtonColor = Colors.white;
            _quizButtonTextColor = Colors.white;
            _studentButtonTextColor = Colors.black;
          });
        },
      ),
    );
  }

  Widget _buildStudentListButton(Color color,Color txtColor) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            color,
          ),
          elevation: MaterialStateProperty.all(3),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5))),
          ),
        ),
        child:Text(
          "Student list",
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: txtColor,
          ),
        ),
        onPressed: () {
          isListBtnClicked = true;
          listMethodCode = 2;
          setState(() {
            _studentButtonColor = Colors.green;
            _quizButtonColor = Colors.white;
            _quizButtonTextColor = Colors.black;
            _studentButtonTextColor = Colors.white;
          });
        },
      ),
    );
  }

}
