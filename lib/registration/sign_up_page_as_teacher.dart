import 'dart:convert';
import 'dart:io';

import 'package:aws_exam_portal/api%20service/api_service.dart';
import 'package:aws_exam_portal/background/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../gradiant_icon.dart';
import 'VerificationAfterRegistration.dart';
import 'log_in_page.dart';


class SignUpAsTeacherScreen extends StatefulWidget {
  const SignUpAsTeacherScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<SignUpAsTeacherScreen> createState() => _SignUpScreenAsTeacherScreenState();
}

class _SignUpScreenAsTeacherScreenState extends State<SignUpAsTeacherScreen> {
  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _emailController = TextEditingController();
  TextEditingController? _phoneNumberController = TextEditingController();
  TextEditingController? _newPasswordController = TextEditingController();
  TextEditingController? _confirmPasswordController = TextEditingController();

  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _isObscure2 = true;
  bool _isObscure3 = true;

  String genderLabelText = "Select Gender";
  String _genderDropDownSelectedValue = "Select Gender";
  final List<String> _genderList = ["Select Gender", "Male", "Female", "Other"];
  String _gender = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.backGroundColor,
        // backgroundColor: Colors.backGroundColor,
        body:

        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child:Stack(
            children: [
              Background(),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ).copyWith(top: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/teacher.png",
                                width: 160,
                                height: 80,
                              )
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const Text(
                          'Create New Account'
                              '\nAs Teacher',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PT-Sans',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.awsMixedColor,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        //full name input
                        _buildTextField(
                          // hintText: 'Full Name',
                            obscureText: false,
                            prefixedIcon: GradientIcon(
                              Icons.person,
                              24,
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
                              24,
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
                              24,
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
                        _buildGenderDropDownMenu(
                            genderList: _genderList,
                            dropdownValue: _genderDropDownSelectedValue),

                        const SizedBox(
                          height: 15,
                        ),

                        //password input
                        _buildTextFieldNewPassword(
                          // hintText: 'Password',
                          obscureText: true,
                          prefixedIcon:GradientIcon(
                            Icons.lock,
                            24,
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
                            24,
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
                          height: 25,
                        ),

                        _buildTermsAndConditionQuestion(),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildSignUpButton(),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildSignUpQuestion(),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          )



        ),
      ),
    );
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();

  }


  _signUp(
      { required String name,
        required String email,
        required String mobile,
        required String password,
        required String gender,
      }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _showLoadingDialog(context,"Creating...");
        try {
          Response response =
          await post(Uri.parse('$BASE_URL_API$SUB_URL_API_SIGN_UP_AS_TEACHER'),
              body: {
            'username': name,
            'email': email,
            'phone_number': mobile,
            'password': password,
            'gender': gender,
          });
           Navigator.of(context).pop();
          if (response.statusCode == 201) {
            _showToast("success");
            var data = jsonDecode(response.body.toString());
            //_showToast(data['message']+". Please Check Your Email!");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VerificationAfterSignUpScreen(
                        data['data']["id"].toString())));

          }
          else if (response.statusCode == 200) {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
          } else {
            var data = jsonDecode(response.body.toString());
            _showToast(data['message']);
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
        cursorColor: Colors.awsCursorColor,
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
        cursorColor: Colors.awsCursorColor,
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

  //Gender Drop Down Menu
  Widget _buildGenderDropDownMenu({
    required List<String> genderList,
    required String dropdownValue,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: genderLabelText,
        labelStyle: const TextStyle(
          color: Colors.hint_color,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: GradientIcon(
          Icons.person,
          24,
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
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.awsEndColor, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.awsStartColor, width: .1),
        ),
        hintStyle: const TextStyle(
          color: Colors.hint_color,
          fontWeight: FontWeight.normal,
          fontFamily: 'PTSans',
        ),
      ),
      value: dropdownValue,
      iconSize: 35,
      isExpanded: true,
      icon: GradientIcon(
        Icons.arrow_drop_down_outlined,
        30,
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
      style: const TextStyle(color: Colors.black, fontSize: 18),
      onChanged: (String? newValue) {
        setState(() {
          _genderDropDownSelectedValue = newValue!;
        });
      },
      items: genderList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
        cursorColor: Colors.awsCursorColor,
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
        cursorColor: Colors.awsCursorColor,
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
        String nameTxt, emailTxt, phoneTxt, passwordTxt, confirmPasswordTxt;
        nameTxt = _nameController!.text;
        emailTxt = _emailController!.text;
        phoneTxt = _phoneNumberController!.text;
        passwordTxt = _newPasswordController!.text;
        confirmPasswordTxt = _confirmPasswordController!.text;
        if (_genderDropDownSelectedValue == "Male") {
          _gender = "1";
        } else if (_genderDropDownSelectedValue == "Female") {
          _gender = "2";
        } else if (_genderDropDownSelectedValue == "Other") {
          _gender = "3";
        } else {
          _gender = "";
        }

        if (_inputValid(nameTxt, emailTxt, phoneTxt, passwordTxt,confirmPasswordTxt,_gender) ==
            false) {
          _signUp(
            name: nameTxt,
            email: emailTxt,
            mobile: phoneTxt,
            password: passwordTxt,
            gender: _gender,
          );
        } else {}
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
      String confirmPassword,String gender ) {
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

    if (gender.isEmpty) {
      _showToast("Please select gender!");
      return;
    }
    if (password.isEmpty) {
      _showToast("password can't empty");
      return;
    }
    if (password.length < 8) {
      _showToast("password can't smaller than 8 digit");
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
        backgroundColor: Colors.awsMixedColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showLoadingDialog(BuildContext context,String message) {
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
                      children:  [
                        SizedBox(
                          width: 10,
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Colors.awsEndColor,
                          color: Colors.awsStartColor,
                          strokeWidth: 5,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          message,
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
