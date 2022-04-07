// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key, String? title}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile ',
        ),
      ),
      body: Column(
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
            title: Center(child: Text('Abdullah')),
            subtitle: Center(child: Text('Arena Web Security Student ')),
          ),
          Padding(padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Flex(direction: Axis.horizontal,
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Name"),
                        Text("Abdullah"),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Flex(direction: Axis.horizontal,
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Name"),
                        Text("Abdullah"),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Flex(direction: Axis.horizontal,
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Name"),
                        Text("Abdullah"),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Flex(direction: Axis.horizontal,
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Name"),
                        Text("Abdullah"),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Flex(direction: Axis.horizontal,
                  children: [
                    Icon(Icons.batch_prediction),
                    SizedBox(width: 20,),
                    Column(
                      children: [
                        Text("Designation"),
                        Text("Teacher"),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
          


        ],
      ),
    );
  }


  _getTeacherRoomDataList(String u_id,String accessToken) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //shimmerStatus = true;
        try {
          var response = await get(
            Uri.parse('$BASE_URL_API$SUB_URL_API_USER_PROFLE$u_id/'),
            headers: {
              "Authorization": "Token $accessToken",
            },
          );

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            _showToast("Success");
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
}
