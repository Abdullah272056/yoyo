import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../gradiant_icon.dart';
import 'log_in_page.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _emailController = TextEditingController();
  TextEditingController? _phoneNumberController = TextEditingController();
  TextEditingController? _newPasswordController = TextEditingController();
  TextEditingController? _confirmPasswordController = TextEditingController();
  TextEditingController? _refCodeController = TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _isObscure2 = true;
  bool _isObscure3 = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.backGroundColor,
        // backgroundColor: Colors.backGroundColor,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ).copyWith(top: 60),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/aws.png",
                          width: 180,
                          height: 90,
                        )
                      ],
                    ),
                  ),


                  const SizedBox(
                    height: 30,
                  ),

                  const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  //full name input
                  _buildTextField(
                      // hintText: 'Full Name',
                      obscureText: false,
                      prefixedIcon: GradientIcon(
                        Icons.person,
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
                      labelText: "Full Name"),

                  const SizedBox(
                    height: 15,
                  ),
                  //email input
                  _buildTextFieldEmail(
                      // hintText: 'Email',
                      obscureText: false,
                      prefixedIcon: GradientIcon(
                        Icons.email,
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

                      labelText: "Email"),
                  const SizedBox(
                    height: 15,
                  ),
                  //phone number input
                  _buildTextFieldPhone(
                      // hintText: 'Phone Number',
                      obscureText: false,
                      prefixedIcon:GradientIcon(
                        Icons.phone,
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

                      labelText: "Phone Number"),

                  const SizedBox(
                    height: 15,
                  ),

                  //password input
                  _buildTextFieldNewPassword(
                    // hintText: 'Password',
                    obscureText: true,
                    prefixedIcon:GradientIcon(
                      Icons.lock,
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
                    labelText: "Password",
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  //confirm password input
                  _buildTextFieldConfirmPassword(
                    // hintText: 'Confirm Password',
                    obscureText: true,
                    prefixedIcon: GradientIcon(
                      Icons.lock,
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
                    labelText: "Confirm Password",
                  ),


                  const SizedBox(
                    height: 35,
                  ),

                  _buildTermsAndConditionQuestion(),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildSignUpButton(),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildSignUpQuestion(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();

  }


  Widget _buildTextField({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Container(
      color: Colors.transparent,
      child: TextField(
        controller: _nameController,
        textInputAction: TextInputAction.next,
        cursorColor: Colors.appRed,
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
          prefixIcon: prefixedIcon,
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



  Widget _buildTextFieldPhone({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Container(
      color: Colors.transparent,
      child: TextField(
        controller: _phoneNumberController,
        cursorColor: Colors.appRed,
        cursorWidth: 1.5,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: prefixedIcon,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsEndColor, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.awsStartColor, width: .2),
          ),
          labelStyle: const TextStyle(
            color: Colors.hint_color,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),
        ),
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9+]+')),
          LengthLimitingTextInputFormatter(
            13,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldEmail({
    required bool obscureText,
    Widget? prefixedIcon,
    String? hintText,
    String? labelText,
  }) {
    return Container(
      color: Colors.transparent,
      child: TextField(
        controller: _emailController,
        cursorColor: Colors.appRed,
        cursorWidth: 1.5,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: prefixedIcon,
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
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.hint_color,
            fontWeight: FontWeight.normal,
            fontFamily: 'PTSans',
          ),
        ),
        keyboardType: TextInputType.emailAddress,
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
        controller: _newPasswordController,
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
              color: Colors.white,
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
        controller: _confirmPasswordController,
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
              color: Colors.appRed,
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
          labelStyle: const TextStyle(
            color: Colors.hint_color,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: () {
        print('Hi there');
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
          child: Text(
            'SIGN UP',
            textAlign: TextAlign.center,
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



  Widget _buildTermsAndConditionQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "By pressing SignUp you agree to the ",
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 10,
            color: Colors.black,
          ),
        ),
        InkWell(
          child: const Text(
            'Terms & Conditions',
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.blue,
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSignUpQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        InkWell(
          child: const Text(
            'Sing In',
            style: TextStyle(
              fontFamily: 'PT-Sans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.awsColor,
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LogInScreen()));
          },
        ),
      ],
    );
  }

  //logic method
  _inputValid(String name, String email, String phone, String password,
      String confirmPassword) {
    if (name.isEmpty) {
      _showToast("Name can't empty");
      return;
    }
    if (email.isEmpty) {
      _showToast("E-mail can't empty");
      return;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _showToast("Enter valid email");
      return;
    }
    if (phone.isEmpty) {
      _showToast("phone can't empty");
      return;
    }
    if (phone.length < 8) {
      _showToast("phone can't smaller than 8 digit");
      return;
    }
    if (phone.length > 13) {
      _showToast("phone can't bigger than 13 digit");
      return;
    }

    if (password.isEmpty) {
      _showToast("password can't empty");
      return;
    }
    if (confirmPassword.isEmpty) {
      _showToast("password can't empty");
      return;
    }
    if (password != confirmPassword) {
      _showToast("Confirm password not match");
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
