import 'package:flutter/material.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 120,
        child:Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child:Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(LightColor.blueLinkedin),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text ("Loading ... ",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight:  FontWeight.w800,
                      fontSize: 25,
                      fontFamily: "mulish")),
              SizedBox(height: 8,)
            ]
        ),
      ),
    );
  }
}