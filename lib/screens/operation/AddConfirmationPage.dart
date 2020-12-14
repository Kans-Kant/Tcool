import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import '../AppBarWidget.dart';
import 'SuiviBudget.dart';

class AddConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context),
         backgroundColor: Color.fromARGB(255, 238, 238, 238),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 150),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset('assets/success.svg'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    getTranslated(context, 'op_succ'),
                    style: TextStyle(
                        color: LightColor.blueLinkedin,//Color(0xff006a71),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SuiviBudget()));
                          },
                          child: Text(
                            getTranslated(context, 'list_op'),
                            style: TextStyle(color: Colors.blue[800]),
                          )))
                ],
              )
              )
            ]
            )
            );
  }

 
}
