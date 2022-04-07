
import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/NoDataFound.dart';
import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';






class HomeForStudentScreen extends StatefulWidget {
  const HomeForStudentScreen({Key? key}) : super(key: key);
  @override
  State<HomeForStudentScreen> createState() => _HomeForStudentScreenState();
}

class _HomeForStudentScreenState extends State<HomeForStudentScreen> {
  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;

  TextEditingController? _classRoomCodeController = TextEditingController();

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";
  bool shimmerStatus = true;

  List studentJoinClassRoomList = [];

  @override
  @mustCallSuper
  initState() {
    super.initState();
    // _getTeacherRoomDataList();
    loadUserIdFromSharePref().then((_) {
      _getStudentRoomDataList(_userId,_accessToken);
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
            title: const Text(
              "Class Room List",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: [
              Center(
                  child: InkResponse(
                    child: const Text(
                      "Join",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    onTap: (){
                      _classRoomCodeController?.clear();
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
                                            "Join New Class Room",
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
                                              labelText: "Class Room Code"),

                                          const SizedBox(
                                            height: 25,
                                          ),
                                          _buildRoomJoinButton(),
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
        body:  RefreshIndicator(
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
              if (shimmerStatus) ...[
                Expanded(
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        _buildClassRoomListShimmer(),
                      ],
                    ))
              ] else ...[
                if (studentJoinClassRoomList != null &&
                    studentJoinClassRoomList.length > 0) ...[
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
                              child: _buildStudentJoinedClassRoomList(),
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
      ),
    );
  }


  Widget _buildClassRoomListShimmer() {
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
  Widget _buildStudentJoinedClassRoomList() {
    return GridView.builder(
        itemCount:
        studentJoinClassRoomList == null ? 0 : studentJoinClassRoomList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Container(
                  width: 160,
                  height: 100,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Flex(direction: Axis.horizontal,
                        children:  [

                          Expanded(child: SizedBox()),
                          PopupMenuButton<int>(
                              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                                new PopupMenuItem<int>(
                                    value: 1, child: new Text('Copy')),
                                new PopupMenuItem<int>(
                                    value: 2, child: new Text('Edit')),
                                new PopupMenuItem<int>(
                                    value: 3, child: new Text('Delete')),
                                new PopupMenuItem<int>(
                                    value: 4, child: new Text('Cancel')),

                              ],
                              onSelected: (int value) {
                                if(value==1){
                                  _showToast("text copied");
                                 /// Clipboard.setData(ClipboardData(text: teacherClassRoomList[index]["class_room_code"].toString()));

                                }
                                if(value==2){
                                  // _classRoomNameUpdateController?.text = teacherClassRoomList[index]["class_room_name"].toString();
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
                                  //                       "Update Class Room",
                                  //                       style: TextStyle(
                                  //                           fontSize: 18,
                                  //                           color: Colors.black,
                                  //                           fontWeight: FontWeight.bold),
                                  //                     ),
                                  //                     const SizedBox(
                                  //                       height: 25,
                                  //                     ),
                                  //
                                  //                     _buildUpdateClassRoomName(
                                  //                         obscureText: false,
                                  //                         labelText: "Class Room Name"),
                                  //
                                  //                     const SizedBox(
                                  //                       height: 25,
                                  //                     ),
                                  //                     _buildRoomUpdateButton(teacherClassRoomList[index]["class_room_id"].toString()),
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
                                }
                                if(value==3){
                                  _showToast("Delete");
                                }

                              }),

                        ],
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Class Room Name",
                              style: TextStyle(
                                color: Colors.awsEndColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                                studentJoinClassRoomList[index]["classroom_info"]["class_room_name"]
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.awsEndColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),

                            SizedBox(height: 15,),

                            Text(
                              "Class Room Code",
                              style: TextStyle(
                                color: Colors.awsEndColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                                studentJoinClassRoomList[index]["classroom_info"]["class_room_code"]
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.awsEndColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700))


                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              _showToast("Clicked Item $index");

            },
          );
        });
  }

  Widget _buildRoomJoinButton() {
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
          'JOIN',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          String classRoomCodeTxt = _classRoomCodeController!.text;
          if (classRoomCodeTxt.isEmpty) {
            _showToast("Class room code can't empty!");
            return;
          }
          Navigator.of(context).pop();
          _joinClassRoom(classRoomCodeTxt,_userId);
          //_showToast(classRoomNameTxt);

        },
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
        controller: _classRoomCodeController,
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

  _joinClassRoom(String roomCode,String u_id) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _showLoadingDialog(context,"Creating...");
        try {
          Response response = await post(
              Uri.parse('$BASE_URL_API$SUB_URL_API_STUDENT_CLASS_ROOM_JOIN'),
              headers: {
                "Authorization": "Token $_accessToken",
              },
              body: {
                'class_room_code': roomCode,
                'student_id': u_id,
              });
          Navigator.of(context).pop();
          if (response.statusCode == 200) {

            _getStudentRoomDataList(_userId,_accessToken);
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
  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_Id)!;
      _accessToken = sharedPreferences.getString(pref_user_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;

    });
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

  _getStudentRoomDataList(String u_id,String accessToken) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        shimmerStatus = true;
        try {
          var response = await get(
            Uri.parse('$BASE_URL_API$SUB_URL_API_STUDENT_ALL_CLASS_ROOM_LIST$u_id/'),
            headers: {
              "Authorization": "Token $accessToken",
            },
          );
          if (response.statusCode == 200) {
            setState(() {
              var data = jsonDecode(response.body);
              studentJoinClassRoomList = data["data"];
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
  void updateDataAfterRefresh() {
    _getStudentRoomDataList(_userId,_accessToken);
    setState(() {});
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


