import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class ReservationDetails extends StatelessWidget {
  final dynamic reservation;
  ReservationDetails(this.reservation);

  @override
  Widget build(BuildContext context) {
    print(this.reservation);
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.background,
      body: ListView(
        padding: EdgeInsets.all(15),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: LightColor.white,
              borderRadius: BorderRadius.all(const Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: LightColor.blueLinkedin,
                  blurRadius: 5.0,
                  offset: Offset(0, 2)
                )
              ]
            ),
            child: Align(
              child: AppTitle(getTranslated(context, 'det_reserv')),
            ),
          ),
          SizedBox(height: 20,),
          _detailsReservation(context)
        ],
      )
    );
  }

  Widget _detailsReservation(BuildContext context) => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: LightColor.white,
      borderRadius: BorderRadius.all(const Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: LightColor.blueLinkedin,
          blurRadius: 5.0,
          offset: Offset(0, 2)
        )
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.event, color: LightColor.greyLinkedin),
              Expanded(child: DetailTitle(
                getTranslated(context, 'date_heure'),
                DateFormat('dd/MM/yyyy - H:mm').format(this.reservation.createdDate),MediaQuery.of(context).size.width * 0.37,
              )),
            ]
          )
        ),
        Divider(height: 2, color: LightColor.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.title, color: LightColor.greyLinkedin),
              Expanded(child: DetailTitle(
                getTranslated(context, 'titre'), this.reservation.field,MediaQuery.of(context).size.width * 0.37,
              ))
            ],
          ),
        ),
        Divider(height: 2, color: LightColor.black,),
        Container(
          child: Row(
            children: <Widget> [
              Icon(Icons.event_available, color: LightColor.greyLinkedin),
              Expanded(
                child: DetailTitle(
                getTranslated(context, 'date_reserv'),
                DateFormat('dd/MM/yyyy').format(this.reservation.day),MediaQuery.of(context).size.width * 0.37,
              ),
              )
            ],
          ),
        ),
        Divider(height: 2, color: LightColor.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.access_time, color: LightColor.greyLinkedin),
              Expanded(child: DetailTitle(
                getTranslated(context, 'hour_reserv'), '${this.reservation.startHour}h',MediaQuery.of(context).size.width * 0.37,
              ))
            ],
          )
        ),  
        Divider(height: 2, color: LightColor.black,),
        Container(
          child: Row(
            children: <Widget> [
              Icon(Icons.group, color: LightColor.greyLinkedin),
              Expanded(
                child: DetailTitle(getTranslated(context, 'number_pers'),  '${this.reservation.numberOfPersons}',MediaQuery.of(context).size.width * 0.37,),
              )
            ],
          ),
        ),
        Divider(height: 2, color: LightColor.black,),
        Container(
          child: Row(
            children: <Widget> [
              Icon(Icons.contact_phone, color: LightColor.greyLinkedin),
              Expanded(
                child: DetailTitle(getTranslated(context, 'contact_pers'), this.reservation.phoneNumber,MediaQuery.of(context).size.width * 0.37,),
              )
            ],
          ),
        ),   
        Divider(height: 2, color: LightColor.black,),
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.more_horiz, color: LightColor.greyLinkedin),
              Expanded(child: DetailTitle(
                getTranslated(context, 'detail'), this.reservation.description,MediaQuery.of(context).size.width * 0.37,
              ))
            ],
          )
        ),     
      ],
    )
    );

}