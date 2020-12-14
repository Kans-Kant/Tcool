import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tcool_flutter/controllers/ReservationController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

class CreateReservation extends StatefulWidget {
  final String terrain;
  final DateTime selectedDay;
  final List<Reservation> reservations;
  CreateReservation(this.terrain, this.selectedDay, this.reservations);

  @override
  _CreateReservationState createState() => _CreateReservationState();
}

class _CreateReservationState extends State<CreateReservation> {
  bool isLoading = false;
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String description;
  String phoneNumber;
  int numberOfParticipant;
  int startHour;

  List<DropdownMenuItem<int>> hourList = [
    DropdownMenuItem(
      child: Text('9h'),
      value: 9,
    ),
    DropdownMenuItem(
      child: Text('10h'),
      value: 10,
    ),
    DropdownMenuItem(
      child: Text('11h'),
      value: 11,
    ),
    DropdownMenuItem(
      child: Text('12h'),
      value: 12,
    ),
    DropdownMenuItem(
      child: Text('13h'),
      value: 13,
    ),
    DropdownMenuItem(
      child: Text('14h'),
      value: 14,
    ),
    DropdownMenuItem(
      child: Text('15h'),
      value: 15,
    ),
    DropdownMenuItem(
      child: Text('16h'),
      value: 16,
    ),
    DropdownMenuItem(
      child: Text('17h'),
      value: 17,
    ),
    DropdownMenuItem(
      child: Text('18h'),
      value: 18,
    ),
    DropdownMenuItem(
      child: Text('19h'),
      value: 19,
    ),
    DropdownMenuItem(
      child: Text('20h'),
      value: 20,
    ),
    DropdownMenuItem(
      child: Text('21h'),
      value: 21,
    )
  ];

  @override
  Widget build(BuildContext context) {
    if(widget.reservations != null) {
      widget.reservations.forEach((res) {
        hourList.removeWhere((element) => element.value == res.startHour);
      });
    }

    print(widget.reservations);
    return Scaffold(
        appBar: MyAppBar2(context),
        backgroundColor: LightColor.white,
        body:Container(
            child:isLoading? Center(
              child: const Loading(),
            ):
            SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Column(children: <Widget>[
                        SizedBox(height: 20),
                        AppTitle(widget.terrain),
                        SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: _formKey,
                          child: formContainer(),
                        )
                      ]))))
    );
  }

  Widget formContainer() => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            decorateTextField(_startHourField()),
            SizedBox(
              height: 8,
            ),
            decorateTextField(_participantsField()),
            SizedBox(
              height: 8,
            ),
            decorateTextField(_phoneNumberField()),
            SizedBox(
              height: 8,
            ),
            decorateTextField(_detailsField()),
            SizedBox(
              height: 20,
            ),
            _validButton(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );

  //--------------------------------------
  Widget decorateTextField(Widget textfield) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin, //LightColor.green,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  //------------------------------------------
  Widget _startHourField() => DropdownButton(
        items: hourList,
         isDense: true,
        underline: Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        value: startHour == null? this.hourList.first.value : startHour,
        onChanged: (value) {
          setState(() {
            startHour = value;
          });
        },
        isExpanded: true,
      );

  //----------------------------------
  Widget _detailsField() => Theme(
      data: Theme.of(context).copyWith(
        primaryColor: LightColor.blueLinkedin, /*LightColor.green1*/
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'detail'),
          labelText: getTranslated(context, 'detail'),
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
        ),
        validator: (value) {
          setState(() {
            description = value;
          });
          return null;
        },
      ));

  //----------------------------------
  Widget _phoneNumberField() => Theme(
      data: Theme.of(context).copyWith(
        primaryColor: LightColor.blueLinkedin, /*LightColor.green1*/
      ),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: getTranslated(context, 'telephone'),
          labelText: getTranslated(context, 'telephone'),
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'saisir_tel');
          if (value.isNotEmpty && value.length < 10)
            return getTranslated(context, 'tel_invalide');
          setState(() {
            phoneNumber = value;
          });
          return null;
        },
      ));

  //-----------------------------------------
  Widget _participantsField() => Theme(
      data: Theme.of(context).copyWith(
          primaryColor: LightColor.blueLinkedin /*LightColor.green1*/),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          labelText: getTranslated(context, 'participant'),
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: "mulish", fontSize: 16),
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'ses_nb_res');
          setState(() {
            numberOfParticipant = int.parse(value);
          });
          return null;
        },
      ));

  //----------------------------------------
  Widget _validButton() => InkWell(
        onTap: () => {validate()},
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            gradient: _gradian(),
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'reserver'),
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: "mulish",
              ),
            ),
          ),
        ),
      );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin, /*LightColor.green1*/ Colors.blue],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  validate() async {
    if (_formKey.currentState.validate()) {
      isLoading = true;
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      Reservation item = new Reservation();
      item.lastModifiedDate = new DateTime.now();
      item.createdDate = new DateTime.now();
      item.createdBy = currentUser['username'];
      item.day = widget.selectedDay;
      item.field = widget.terrain;
      item.numberOfPersons = numberOfParticipant;
      item.phoneNumber = phoneNumber;
      startHour != null? item.startHour = startHour : item.startHour = this.hourList.first.value;
      item.description = description;

      await ReservationController()
          .saveReservation(item, context)
          .then((value) {
        isLoading = false;
        Navigator.of(context).pop(item);
      });
    }
  }
}
