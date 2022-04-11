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

                      "Create\nQuestion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    onTap: (){
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


                      // showModalBottomSheet<dynamic>(
                      //   backgroundColor: Colors.white,
                      //   isDismissible: true,
                      //   context: context,
                      //
                      //   isScrollControlled: true,
                      //   builder: (BuildContext context) {
                      //
                      //     return StatefulBuilder(
                      //         builder: (BuildContext context, StateSetter setState) {
                      //           return  Padding(
                      //             padding:
                      //             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      //             //const EdgeInsets.only(left: 15, top: 5, right: 10, bottom: 10),
                      //             child:SingleChildScrollView(
                      //               child: Padding(
                      //                 padding:
                      //                 const EdgeInsets.only(left: 15, top: 5, right: 10, bottom: 10),
                      //                 child: Column(
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: <Widget>[
                      //                     Center(
                      //                       // child: Icon(Icons.arrow_drop_down_sharp,size: 40,),
                      //                       child: InkWell(
                      //                         child: Image.asset(
                      //                           "assets/images/drop_down.png",
                      //                           width: 40,
                      //                           height: 20,
                      //                         ),
                      //                         onTap: () {
                      //                           Navigator.of(context).pop();
                      //                         },
                      //                       ),
                      //                     ),
                      //                     const SizedBox(
                      //                       height: 15,
                      //                     ),
                      //                     const Text(
                      //                       "Create Question",
                      //                       style: TextStyle(
                      //                           fontSize: 18,
                      //                           color: Colors.black,
                      //                           fontWeight: FontWeight.bold),
                      //                     ),
                      //                     const SizedBox(
                      //                       height: 25,
                      //                     ),
                      //
                      //                     _buildTextField(
                      //                         obscureText: false,
                      //                         labelText: "Quiz Name"),
                      //
                      //                     const SizedBox(
                      //                       height: 25,
                      //                     ),
                      //                     _buildRoomAddButton(),
                      //                     const SizedBox(
                      //                       height: 15,
                      //                     ),
                      //
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           )
                      //           ;
                      //         });
                      //   },
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.only(
                      //         topLeft: Radius.circular(25.0),
                      //         topRight: Radius.circular(25.0)),
                      //   ),
                      // );

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

            //updateDataAfterRefresh();
          },
          child: Flex(
            direction: Axis.vertical,
            children: [

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
          //_createQuizName(quizNameTxt,_userId);
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
                    Expanded(
                      child: Container(
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

  Widget _buildExploreCityListShimmer1() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ListView(
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: GridView.builder(
                        itemCount: 16,
                        physics: const NeverScrollableScrollPhysics(),
                        // physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child: Container(
                                width: 160,
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

  // _createQuizName(String quizName,String u_id) async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       _showLoadingDialog(context,"Creating...");
  //       try {
  //         Response response = await post(
  //             Uri.parse('$BASE_URL_API$SUB_URL_API_TEACHER_QUIZ_CREATE'),
  //             headers: {
  //               "Authorization": "Token $_accessToken",
  //             },
  //             body: {
  //               'quiz_title': quizName,
  //               'teacher_id': u_id,
  //               'class_room_id': _classRoomId,
  //
  //             });
  //         Navigator.of(context).pop();
  //         if (response.statusCode == 201) {
  //
  //
  //           _getTeacherIndividualClassroomQuizList(_classRoomId,_accessToken);
  //           setState(() {
  //             _showToast("success");
  //           });
  //         }
  //         else if (response.statusCode == 401) {
  //           var data = jsonDecode(response.body.toString());
  //           _showToast(data['message']);
  //         }
  //         else {
  //           var data = jsonDecode(response.body.toString());
  //           if(data['message']!=null){
  //             _showToast(data['message']);
  //           }
  //           else{
  //             _showToast("Failed try again!");
  //           }
  //         }
  //       } catch (e) {
  //         Navigator.of(context).pop();
  //         print(e.toString());
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     Fluttertoast.cancel();
  //     _showToast("No Internet Connection!");
  //   }
  // }

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
