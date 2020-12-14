import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Code.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import 'MainScreen.dart';
import 'acceuil.dart';

class IntroScreen extends StatefulWidget {

  @override
  _IntroScreenScreenState createState() =>
      _IntroScreenScreenState();
}

class _IntroScreenScreenState extends State<IntroScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController()
    ..text = "";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String _code = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  bool isLoading =false;

  bool isVerify = false;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.white,
      body: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30),
                    Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child:Container(
                          padding: const EdgeInsets.only(top:25),
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Image.asset(
                            "assets/SUN SQUARE ALMAZ.jpg",
                            fit: BoxFit.cover,
                            height: 160,
                          ),
                        )
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        getTranslated(context, 'code_verification') ,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,fontFamily: "mulish"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                      child: RichText(
                        text: TextSpan(
                            text: getTranslated(context, 'ses_cr') ,
                            style: TextStyle(color: Colors.black, fontSize: 15,fontFamily: "mulish")),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          child: PinCodeTextField(
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.none,
                            validator: (v) {
                              if (v.length < 6) {
                                return " Empty Cell !!!";
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor:Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedFillColor: Colors.white,
                            ),
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: textEditingController,
                            onCompleted: (v) {
                              print("Completed");
                            },
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                _code = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError ? getTranslated(context, 'remplir_code')  : "",
                        style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400,fontFamily: "mulish"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      margin:const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                      child: ButtonTheme(
                        height: 50,
                        child: FlatButton(
                          onPressed: () {
                            formKey.currentState.validate();
                            // conditions for validating
                            if (_code.length != 6 ) {
                              errorController.add(ErrorAnimationType
                                  .shake); // Triggering error shake animation
                              setState(() {
                                hasError = true;
                              });
                            } else {
                              setState(() {
                                hasError = false;
                                verifycode();
                              });
                            }
                          },
                          child: Center(
                              child: Text(
                                getTranslated(context, 'verifier'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "mulish",
                                ),
                              )),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: LightColor.blueLinkedin,
                          borderRadius: BorderRadius.circular(25.0),
                          gradient: _gradian(),
                          boxShadow: [
                            BoxShadow(
                                color: LightColor.blueLinkedin,
                                offset: Offset(1, -2),
                                blurRadius: 2),
                          ]),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Text(getTranslated(context, 'effac'),
                            style: TextStyle(
                              fontFamily: "mulish",
                            ),
                          ),
                          onPressed: () {
                            textEditingController.clear();
                          },
                        ),
                        /*FlatButton(
                          child: Text("Set Text",
                            style: TextStyle(
                              fontFamily: "mulish",
                            ),
                          ),
                          onPressed: () {
                            textEditingController.text = "******";
                          },
                        ),*/
                      ],
                    )
                  ],
                ),
              ),
            ),
            Center(
                child: isLoading ? CircularProgressIndicator(strokeWidth: 5,) : Container()
            )
          ]),
    );
  }

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/,Colors.blue /*LightColor.green1*/],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  //------------------------------------
  verifycode() async {

    if (formKey.currentState.validate()) {
      //isLoading = true;
      print('code : ' + _code);
      Map body = {
        "code": _code
      };
      try {
        isLoading =true;
        var response = await http.post(
          Constants.CODE_VERIFY,
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
        if (response.statusCode == 200) {
          isLoading =false;
          Map parsed = json.decode(response.body);
          var code = parsed['message'];
          print(code);
          await storage.write(key: "code", value: code);
          //code verify successfully
          Timer(Duration(seconds: 2), () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Acceuil()));
          });
        } else {
          if (response.statusCode == 400) {
            // error code
            Timer(Duration(seconds: 2), () {
              this.setState(() {
                isLoading = false;
              });
            });
            //Map parsed = json.decode(response.body);
            //Utils.showAlertDialog(context, parsed['message']);
            errorController.add(ErrorAnimationType
                .shake);
          } else {
            isLoading = false;
            errorController.add(ErrorAnimationType
                .shake);
            throw new Exception("Error!");
          }
        }
      } catch (e) {
        isLoading = false;
        isVerify = false;
        //Utils.showAlertDialog(context, 'Please check back Your Code Please'/*getTranslated(context, 'error_creat')*/);
        /*Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Acceuil()));*/
      }
    }
  }
}
