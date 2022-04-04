import 'dart:convert';

import 'dart:io';

import 'package:aws_exam_portal/api%20service/NoDataFound.dart';
import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/api%20service/sharePreferenceDataSaveName.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../gradiant_icon.dart';

class HomeForTeacherScreen extends StatefulWidget {
  const HomeForTeacherScreen({Key? key}) : super(key: key);

  @override
  State<HomeForTeacherScreen> createState() => _HomeForTeacherScreenState();
}

class _HomeForTeacherScreenState extends State<HomeForTeacherScreen> {
  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? _classRoomNameController = TextEditingController();
  bool _isObscure = true;

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  bool shimmerStatus = true;
  List teacherClassRoomList = [];
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
        appBar: AppBar(
            leading: IconButton(
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, true);
                // Fluttertoast.showToast(
                //     msg: "Back Button clicked",
                //     toastLength: Toast.LENGTH_SHORT,
                //     gravity: ToastGravity.CENTER,
                //     timeInSecForIosWeb: 1
                // );
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
                  "Create",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                    onTap: (){

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
                                            "Create New Class Room",
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
                                              labelText: "Class Room Name"),

                                          const SizedBox(
                                            height: 25,
                                          ),
                                          _buildFilterButton(),
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
                if (teacherClassRoomList != null &&
                    teacherClassRoomList.length > 0) ...[
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
                    child: NoDataFound().noItemFound("NO ROOM FOUND!"),
                  ),
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
        controller: _classRoomNameController,
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
  Widget _buildFilterButton() {
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
          'Add',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          _showToast("Ok");

        },
      ),
    );
  }

  Widget _buildTeacherClassRoomList() {
    return GridView.builder(
        itemCount:
            teacherClassRoomList == null ? 0 : teacherClassRoomList.length,
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
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Class Room Name",
                                style: TextStyle(
                                  color: Colors.awsEndColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                  teacherClassRoomList[index]["class_room_name"]
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.awsEndColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Class Room Code",
                                style: TextStyle(
                                  color: Colors.awsEndColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                  teacherClassRoomList[index]["class_room_code"]
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.awsEndColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              //_showToast("Clicked Item $index");

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => RoomDetailsScreen(
              //             offerDataList[index]["room_id"].toString())));
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

  _getTeacherRoomDataList(String u_id) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        shimmerStatus = true;
        try {
          var response = await get(
            Uri.parse(
                '$BASE_URL_API$SUB_URL_API_TEACHERS_ALL_CLASS_ROOM_LIST$u_id/'),
          );

          if (response.statusCode == 200) {
            setState(() {
              //_showToast("success");
              var data = jsonDecode(response.body);
              teacherClassRoomList = data["data"];
              //_showToast(teacherClassRoomList.length.toString());
              shimmerStatus = false;
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

  void updateDataAfterRefresh() {
    _getTeacherRoomDataList(_userId);
    setState(() {});
  }

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getString(pref_user_Id) != null) {
        _userId = sharedPreferences.getString(pref_user_Id)!;
      } else {
        _userId = "30";
      }
    });
  }
}
