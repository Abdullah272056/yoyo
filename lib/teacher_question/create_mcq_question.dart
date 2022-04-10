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


class CreateMCQQuestionScreen extends StatefulWidget {

  @override
  State<CreateMCQQuestionScreen> createState() => _CreateMCQQuestionScreenState();
}

class _CreateMCQQuestionScreenState extends State<CreateMCQQuestionScreen> {
  TextEditingController? _shortQuestionNameController = TextEditingController();
  TextEditingController? _shortQuestionOptionNameController = TextEditingController();
  TextEditingController? _classRoomNameUpdateController = TextEditingController();
  bool _isObscure = true;

  TextEditingController? otpEditTextController = new TextEditingController();
  String _otpTxt = "";
  String _userId = "";
  String _accessToken = "";
  String _refreshToken = "";

  bool shimmerStatus = true;

  List optionList = [];

  var teacherIndividualClassRoomQuizListResponse;

  int selectedValue = -1;
  String selectedValueText ="";

  @override
  @mustCallSuper
  initState() {
    super.initState();
    // _getTeacherRoomDataList();
    loadUserIdFromSharePref().then((_) {
      // _getTeacherIndividualClassroomQuizList(_classRoomId,_accessToken);
    });
    //loadUserIdFromSharePref();
  }

  @override
  Widget build(BuildContext context)  {
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
            title:  Text(
              "Create MCQ Question",
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
        body: RefreshIndicator(
          color: Colors.white,
          backgroundColor: Colors.purple,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));

            //updateDataAfterRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ).copyWith(top: 5, bottom: 10),
            child:Flex(
              direction: Axis.vertical,
              children: [
                const SizedBox(height: 20,),
                Expanded(child:Flex(
                   direction:Axis.vertical,
                  children: [
                    _buildTextField(),
                    const SizedBox(height: 15,),
                    _buildAddButton(),
                    SizedBox(height: 15,),
                    Expanded(child: StatefulBuilder(
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

                                    Container(
                                      color: Colors.transparent,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Colors.appRed,
                                        ),
                                        child: Column(
                                          children: [

                                            ListView.builder(
                                              itemCount: optionList == null ? 0 : optionList.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return RadioListTile<int>(
                                                    value: index,
                                                    activeColor: Colors.appRed,
                                                    title: Text(
                                                      optionList[index].toString(),
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                    groupValue: selectedValue,
                                                    onChanged: (value) => setState(() {
                                                      selectedValue = index;
                                                      selectedValueText="Cox's Bazar";
                                                    })
                                                );
                                              },
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          )
                          ;
                        }),)

                  ],
                )),

                _buildSaveButton(),
                const SizedBox(height: 15,),


              ],
            ),

          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hintText,
    String? labelText,
  }) {
    return TextFormField(
      controller: _shortQuestionNameController,
      minLines: 4,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: 'Enter your question',
          hintStyle: TextStyle(
              color: Colors.grey
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )
      ),
    );
  }

  Widget _buildOptionTextField({
    String? hintText,
    String? labelText,
  }) {
    return TextFormField(
      controller: _shortQuestionOptionNameController,
      minLines: 2,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: 'Enter option',
          hintStyle: TextStyle(
              color: Colors.grey
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          )
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {

        String shortQuestionTxt = _shortQuestionNameController!.text;

        if (shortQuestionTxt.isEmpty) {
          Fluttertoast.cancel();
          _showToast("question can't empty");
          return;
        }

        //_createShortQuestion(shortQuestionTxt);
        ///////////
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.awsStartColor, Colors.awsEndColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(7.0)),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(
            "Save",
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

  Widget _buildAddButton() {
    return  Flex(direction: Axis.horizontal,
      children: [
        Expanded(child: _buildOptionTextField(),),
        SizedBox(width: 10,),
        InkResponse(
          child: Ink(

            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.awsMixedColor, Colors.awsMixedColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(7.0)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15,right: 15),
              alignment: Alignment.center,
              child: Text(
                "Add",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PT-Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onTap: (){
            if(optionList.length<6){
              String optionTxt = _shortQuestionOptionNameController!.text;

              if (optionTxt.isEmpty) {
                Fluttertoast.cancel();
                _showToast("Option can't empty");
                return;
              }
              optionList.add(optionTxt);
              _shortQuestionOptionNameController?.clear();

            }
            else{

            }

            setState(() {

            });
          },
        ),
        SizedBox(width: 10,),
      ],
    );
  }





  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
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
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        const CircularProgressIndicator(
                          backgroundColor: Colors.appRed,
                          strokeWidth: 5,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          message,
                          style: const TextStyle(fontSize: 20),
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


  loadUserIdFromSharePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = sharedPreferences.getString(pref_user_Id)!;
      _accessToken = sharedPreferences.getString(pref_user_token)!;
      _refreshToken = sharedPreferences.getString(pref_user_refresh_token)!;

    });
  }

}
