import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../gradiant_icon.dart';


class NewPasswordSetScreen extends StatefulWidget {
  String userId;
  NewPasswordSetScreen(this.userId, {Key? key}) : super(key: key);

  @override
  State<NewPasswordSetScreen> createState() =>
      _NewPasswordSetScreenState(this.userId);
}

class _NewPasswordSetScreenState extends State<NewPasswordSetScreen> {
  late String userId;
  _NewPasswordSetScreenState(this.userId);

  TextEditingController? newPassword = TextEditingController();
  TextEditingController? confirmPassword = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _isObscure2 = true;
  bool _isObscure3 = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _bodyDesign(),
    );
  }

  Widget _bodyDesign() {
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
            "Set New Password",
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
                  colors: <Color>[
                    Colors.awsEndColor,
                    Colors.awsStartColor
                  ],
                ),
              ),
            )
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ).copyWith(top: 0, bottom: 50),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/reset_password_icon.png",
                          width: 110,
                          height: 110,
                        )
                      ],
                    ),
                  ),
                  // Image.asset('assets/images/profile.jpg'),

                  // Image.asset('assets/images/profile.jpg'),
                  const SizedBox(
                    height: 50,
                  ),

                  _buildTextFieldNewPassword(
                    // hintText: 'Password',
                    obscureText: true,
                    prefixedIcon: GradientIcon(
                      Icons.lock,
                      26,
                      const LinearGradient(
                        colors: <Color>[
                          Colors.awsStartColor,
                          Colors.awsStartColor,
                          Colors.awsEndColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    labelText: "New Password",
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  //phone number input

                  //password input
                  _buildTextFieldConfirmPassword(
                    // hintText: 'Password',
                    obscureText: true,
                    prefixedIcon: GradientIcon(
                      Icons.lock,
                      26,
                      const LinearGradient(
                        colors: <Color>[
                          Colors.awsStartColor,
                          Colors.awsStartColor,
                          Colors.awsEndColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    labelText: "Confirm Password",
                  ),

                  const SizedBox(
                    height: 45,
                  ),
                  _buildChangePasswordButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldNewPassword({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        cursorColor: Colors.appRed,
        cursorWidth: 1.5,
        controller: newPassword,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        focusNode: _newPasswordFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, _newPasswordFocus, _confirmPasswordFocus);
        },
        obscureText: _isObscure2,
        // obscuringCharacter: "*",
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          // border: InputBorder.none,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          // labelText: 'Password',
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
              color: Colors.appRed,
              icon: GradientIcon(
                _isObscure2 ? Icons.visibility_off : Icons.visibility,
                26,
                LinearGradient(
                  colors: <Color>[
                    Colors.awsStartColor,
                    Colors.awsStartColor,
                    Colors.awsEndColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              onPressed: () {
                setState(() {
                  _isObscure2 = !_isObscure2;
                });
              }),

          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),

          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsEndColor, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsStartColor, width: .2),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.hint_color,
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _buildTextFieldConfirmPassword({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        cursorColor: Colors.appRed,
        cursorWidth: 1.5,
        controller: confirmPassword,
        focusNode: _confirmPasswordFocus,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        obscureText: _isObscure3,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          // border: InputBorder.none,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          // labelText: 'Password',
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
              color: Colors.awsColor,
              icon: GradientIcon(
                _isObscure3 ? Icons.visibility_off : Icons.visibility,
                26,
                LinearGradient(
                  colors: <Color>[
                    Colors.awsStartColor,
                    Colors.awsStartColor,
                    Colors.awsEndColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              onPressed: () {
                setState(() {
                  _isObscure3 = !_isObscure3;
                });
              }),

          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),

          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsEndColor, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsStartColor, width: .2),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.hint_color,
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton1() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.appRed,
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
          'SET PASSWORD',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          String newPasswordTxt, confirmPasswordTxt;
          newPasswordTxt = newPassword!.text;
          confirmPasswordTxt = confirmPassword!.text;

          if (_inputValid(newPasswordTxt, confirmPasswordTxt) == false) {
            // Navigator.push(context,MaterialPageRoute(builder: (context)=>LogInScreen()));
           // _setResetNewPassword(newPassword: confirmPasswordTxt, userId: userId);
          }
        },
      ),
    );
  }
  Widget _buildChangePasswordButton() {
    return ElevatedButton(
      onPressed: () {

      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7))),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.awsStartColor, Colors.awsEndColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(7.0)
        ),
        child: Container(

          height: 50,
          alignment: Alignment.center,
          child:  Text(
            'SET PASSWORD',
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _inputValid(String newPassword, String confirmPassword) {
    if (newPassword.isEmpty) {
      Fluttertoast.cancel();
      _showToast("New password can't empty");
      return;
    }
    if (confirmPassword.isEmpty) {
      Fluttertoast.cancel();
      _showToast("Confirm password can't empty");
      return;
    }
    if (newPassword != confirmPassword) {
      Fluttertoast.cancel();
      _showToast("Confirm password do not match");
      return;
    }

    return false;
  }

  _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // _setResetNewPassword({
  //   required String userId,
  //   required String newPassword,
  // }) async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       _showLoadingDialog(context);
  //       try {
  //         Response response = await put(
  //             Uri.parse(
  //                 '$BASE_URL_API$SUB_URL_API_RESET_CONFIRM_PASSWORD$userId/'),
  //             body: {'new_password': newPassword});
  //         Navigator.of(context).pop();
  //         print("StatusCodeVerify=" + response.statusCode.toString());
  //         if (response.statusCode == 200) {
  //           _showToast("success");
  //           // var data=jsonDecode(response.body.toString());
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => const LogInScreen(),
  //             ),
  //             (route) => false,
  //           );
  //         } else if (response.statusCode == 400) {
  //           var data = jsonDecode(response.body.toString());
  //           _showToast(data['message']);
  //         } else {
  //           var data = jsonDecode(response.body.toString());
  //           _showToast(data['message']);
  //         }
  //       } catch (e) {
  //         print(e.toString());
  //         Navigator.of(context).pop();
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     Fluttertoast.cancel();
  //     _showToast("No Internet Connection!");
  //   }
  // }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
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
                      children: const [
                        SizedBox(
                          width: 10,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Colors.appRed,
                          color: Colors.black,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Checking...",
                          style: TextStyle(fontSize: 20),
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
