import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/AppBarWidget4.dart';
import 'dart:convert';


class ShowImage extends StatefulWidget {
  final String image;

  ShowImage({Key key, @required this.image}) : super(key: key);
  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar4(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_setImageView()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _setImageView() {
    if (this.widget.image != null) {
      return Image.memory( base64.decode(this.widget.image), width: 500, height: 500);
    } else {
      return Text(getTranslated(context, 'no_img_av'));
    }
  }
}
