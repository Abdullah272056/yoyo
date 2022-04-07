import 'package:aws_exam_portal/home_page/profile/profile_page.dart';
import 'package:aws_exam_portal/registration/log_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page_for_teacher.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Aws Exam Portal',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[Colors.awsEndColor, Colors.awsStartColor],
                ),
              ),
          ),
          ListTile(
            leading: Icon(Icons.notification_important_rounded),
            title: Text('Notification'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,MaterialPageRoute(builder: (context)=>const ProfilePageScreen()));
          },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => LogInScreen(),
                ),
                    (route) => false, //if you want to disable back feature set to false
              );
            },
          ),
        ],
      ),
    );
  }
}