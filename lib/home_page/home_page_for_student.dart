
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

  TextEditingController? _classRoomNameController = TextEditingController();

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";

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
                      _classRoomNameController?.clear();
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
                                          _buildRoomAddButton(),
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
          'JOIN',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          String classRoomNameTxt = _classRoomNameController!.text;
          if (classRoomNameTxt.isEmpty) {
            _showToast("Class room name can't empty!");
            return;
          }
          Navigator.of(context).pop();
         // _createClassRoomName(classRoomNameTxt,_userId);
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

