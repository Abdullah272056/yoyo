
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';






class HomeForStudentScreen extends StatefulWidget {
  const HomeForStudentScreen({Key? key}) : super(key: key);
  @override
  State<HomeForStudentScreen> createState() => _HomeForStudentScreenState();
}

class _HomeForStudentScreenState extends State<HomeForStudentScreen> {
  TextEditingController? phoneNumberController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  bool _isObscure = true;



  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.backGroundColor,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 20),
              child: Column(
                children: [
                  Text("Home Page"),
                ],
              ),
            ),
          )

          ,
        ),
      ),
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

  void _showLoadingDialog(BuildContext context){
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
                      children: const [
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
                          "Checking...",
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


