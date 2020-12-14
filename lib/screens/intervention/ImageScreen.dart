import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Intervention.dart';
import 'dart:convert';

import 'package:tcool_flutter/screens/AppBarWidget.dart';

class ImageScreen extends StatefulWidget {
  final Intervention intervention;

  ImageScreen({Key key, @required this.intervention}) : super(key: key);
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File imageFile;
  var image;

  @override
  void initState() {
    super.initState();
    if (this.widget.intervention.images != null) {
      image = base64.decode(this.widget.intervention.images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context),
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
    if (image != null) {
      return Image.memory(image, width: 500, height: 500);
    } else {
      return Text(getTranslated(context, 'no_img_av'));
    }
  }
}
