import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/reservation/CreateReservation.dart';
import 'package:tcool_flutter/screens/reservation/reservation_details.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tcool_flutter/screens/widgets/slide_top_route.dart';

class DayEventView extends StatefulWidget {
  final DateTime selectedDay;
  final String terrain;
  List<Reservation> reservations;
  DayEventView({Key key, this.selectedDay, this.reservations, this.terrain})
      : super(key: key);
  @override
  _DayEventViewState createState() => _DayEventViewState();
}

class _DayEventViewState extends State<DayEventView> {
  // added events
  List<FlutterWeekViewEvent> events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.reservations != null) {
      widget.reservations.forEach((element) {
        events.add(FlutterWeekViewEvent(
            title: element.field,
            description: element.field,
            start: new DateTime(element.day.year, element.day.month,
                element.day.day, element.startHour, 0),
            end: new DateTime(element.day.year, element.day.month,
                    element.day.day, element.startHour, 0)
                .add(new Duration(hours: 1)),
            backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(.9),
            onTap: () {
              Navigator.of(context).push(SlideRightRoute(page: ReservationDetails(element)));
            }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'list_reserv'),
            style: TextStyle(color: Colors.white)),
        backgroundColor: LightColor.blueLinkedin,
        leading: BackButton(color: LightColor.icon, onPressed: () {
          Navigator.pop(context,);
        }),
        actions: [
          IconButton(
            onPressed: () async {
              Reservation item = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateReservation(
                          widget.terrain, widget.selectedDay, widget.reservations )));

              setState(() {
                if(item != null ) {
                  widget.reservations.add(item);
                  events.add(FlutterWeekViewEvent(
                      title: item.createdBy != null? 'Rervation de ${item.createdBy}' : "Heure prise",
                      start: new DateTime(item.day.year, item.day.month,
                          item.day.day, item.startHour, 0),
                      onTap: () {
                        Navigator.of(context).push(SlideRightRoute(page: ReservationDetails(item)));
                      },
                      backgroundColor:
                          Color((Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(.9),
                      end: new DateTime(item.day.year, item.day.month,
                              item.day.day, item.startHour, 0)
                          .add(new Duration(hours: 1)),
                      description: item.description));

                }
              });
            },
            icon: Icon(
              Icons.add_box,
              color: LightColor.white,
            ),
          ),
        ],
      ),
      body: DayView(
        date: this.widget.selectedDay,
        events: events,
        minimumTime: HourMinute(hour: 7, minute: 30),
        maximumTime: HourMinute(hour: 22, minute: 30),
        dayBarStyle: DayBarStyle(
            color: Color.fromARGB(225, 128, 128, 128),
            textAlignment: Alignment.center,
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        style: DayViewStyle(backgroundColor: Colors.blueGrey[50]),
      ),
    );
  }
}
