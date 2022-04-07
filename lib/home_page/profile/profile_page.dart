
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



class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({Key? key}) : super(key: key);
  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {

  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";

  String _name="------";
  String _email="------";
  String _phone="------";
  String _desination="------";
  String _desination2="";
  String _gender="------";


  @override
  @mustCallSuper
  initState() {
    super.initState();
    // _getTeacherRoomDataList();
    loadUserIdFromSharePref().then((_) {
      _getUserData(_userId,_accessToken);
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
              "My Information",
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
        body:  Column(
          children: [
            Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.awsStartColor,
                            Colors.awsEndColor,
                          ],
                        )),
                    height: MediaQuery.of(context).size.height / 4.5,
                  ),
                  Positioned(
                      bottom: -50.0,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/images/student.png'),
                      ))
                ]),
            SizedBox(
              height: 45,
            ),

            ListTile(
              title: Center(child: Text(_name)),
              subtitle: Center(child: Text('Arena Web Security '+_desination2)),
            ),

            Padding(padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileItem(header: "Name",value: _name,prefixedIcon: Icon(Icons.person)),
                  SizedBox(height: 20,),
                  _buildProfileItem(header: "Email",value: _email,prefixedIcon: Icon(Icons.email)),
                  SizedBox(height: 20,),
                  _buildProfileItem(header: "Contact",value: _phone,prefixedIcon: Icon(Icons.phone)),
                  SizedBox(height: 20,),

                  _buildProfileItem(header: "Gender",value: _gender,prefixedIcon: Icon(Icons.person)),
                  SizedBox(height: 20,),

                  _buildProfileItem(header: "Designation",value: _desination,prefixedIcon: Icon(Icons.batch_prediction)),
                  SizedBox(height: 20,),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
  Widget _buildProfileItem(
      {
        required Widget prefixedIcon,
        required String header,
        required String value,

      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        prefixedIcon,
        const SizedBox(
          width: 15,
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              header,
              style:TextStyle(
                fontFamily: 'PT-Sans',
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'PT-Sans',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),),

      ],
    );
  }
  _getUserData(String u_id,String accessToken) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _showLoadingDialog(context,"loading");
        //shimmerStatus = true;
        try {
          var response = await get(
            Uri.parse('$BASE_URL_API$SUB_URL_API_USER_PROFLE$u_id/'),
            headers: {
              "Authorization": "Token $accessToken",
            },
          );
          Navigator.of(context).pop();
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);

            _name=data["data"]["username"].toString();
            _email=data["data"]["email"].toString();
            _phone=data["data"]["phone_number"].toString();

            if(data["data"]["gender"].toString()=="1"){
              _gender="Male";
            }
            else if(data["data"]["gender"].toString()=="2"){
              _gender="Female";
            }
            else if(data["data"]["gender"].toString()=="3"){
              _gender="Others";
            }

            if(data["data"]["is_teacher"]==true){
              _desination="Teacher";
              _desination2="Teacher";
            }
            else{
              _desination="Student";
              _desination2="Student";
            }
            setState(() {

            });

            _showToast("Success");
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

  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_Id)!;
      _accessToken = sharedPreferences.getString(pref_user_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;

    });
  }
}


