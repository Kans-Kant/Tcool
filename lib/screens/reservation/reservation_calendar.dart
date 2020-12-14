import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:tcool_flutter/controllers/ReservationController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';
import 'package:tcool_flutter/screens/widgets/slide_top_route.dart';
import 'package:tcool_flutter/themes/light_color.dart';

import '../AppBarWidget2.dart';
import 'day_view.dart';
import 'reservation_details.dart';

class CalendarPage extends StatefulWidget {
  final String terrain;
  CalendarPage(this.terrain);

  static void setLocale(BuildContext context, Locale locale) {
    _CalendarPageState state =
        context.findAncestorStateOfType<_CalendarPageState>();
    state.setLocale(locale);
  }

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  //Map<DateTime, List> _events = {};
  List _selectedEvents;
  DateTime _day;
  AnimationController _animationController;
  CalendarController _calendarController;
  Locale _locale; //= Localizations.localeOf(context);
  List<Reservation> disList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedEvents = new List<Reservation>();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
/*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCalendar().then((value) => setState(() {
            _events = value;
          }));
    });*/
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((value) {
      setState(() {
        this._locale = value;
      });
    });
    super.didChangeDependencies();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      if (events != null) {
        _selectedEvents = events;
      } else {
        _selectedEvents = new List<Reservation>();
      }
      _day = day;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      body: Container(
        child: FutureBuilder(
            future: ReservationController().getAllReservations(context),
            builder: (context, AsyncSnapshot<List<Reservation>> snapshot) {
              if (!snapshot.hasData) return initCalendar({});
              if (snapshot.data.length == 0) return initCalendar({});
              Map<DateTime, List> mapFetch = {};
              Future.delayed(const Duration(seconds: 1), () {});
              disList = snapshot.data;
              for (int i = 0; i < disList.length; i++) {
                List<Reservation> temp = new List();
                for (int j = 0; j < disList.length; j++) {
                  if ((disList[i].day.day == disList[j].day.day) &&
                      (disList[i].day.month == disList[j].day.month) &&
                      (disList[i].day.year == disList[j].day.year))
                    temp.add(disList[j]);
                }
                mapFetch[disList[i].day] = temp;
              }
              print(mapFetch);
              return initCalendar(mapFetch);
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(SlideTopRoute(
              page: DayEventView(
                  selectedDay: _day != null ? _day : new DateTime.now(),
                  reservations: List<Reservation>.from(_selectedEvents),
                  terrain: widget.terrain)));
        },
        backgroundColor: Color.fromARGB(255, 40, 103, 178),
        tooltip: getTranslated(context, 'add_reservation'),
        child: Icon(Icons.add),
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(Map<DateTime, List> _events) {
    return TableCalendar(
      locale: "${_locale.languageCode}_${_locale.countryCode}",
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideWeekendStyle: TextStyle(color: Colors.grey.shade900),
        weekendStyle:
            TextStyle().copyWith(color: Color.fromARGB(255, 40, 103, 178)),
        holidayStyle:
            TextStyle().copyWith(color: Color.fromARGB(255, 40, 103, 178)),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextBuilder: (date, locale) {
          return DateFormat.E(locale).format(date).substring(0, 3);
        },
        weekendStyle: TextStyle().copyWith(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.lightBlue[200],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8)),
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              width: 100,
              height: 100,
              child: Center(
                  child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              )),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            decoration: new BoxDecoration(
                color: Colors.lightBlueAccent[700],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8)),
            width: 100,
            height: 100,
            child: Center(
                child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            )),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events, null);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Color.fromARGB(255, 40, 103, 178)
            : _calendarController.isToday(date)
                ? Color.fromARGB(255, 40, 103, 178)
                : Color.fromARGB(255, 40, 103, 178),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 40, 103, 178),
                    child: event.field == getTranslated(context, 'basket')
                        ? SvgPicture.asset(
                            'assets/sports_basketball.svg',
                            color: LightColor.white,
                          )
                        : SvgPicture.asset(
                            'assets/sports_soccer.svg',
                            color: LightColor.white,
                          ),
                  ),
                  title: Text('${event.field} occupé à ${event.startHour}h'),
                  onTap: () {
                    print('${event.field} tapped!');
                    Navigator.of(context)
                        .push(SlideTopRoute(page: ReservationDetails(event)));
                  },
                ),
              ))
          .toList(),
    );
  }

  Widget initCalendar(Map<DateTime, List> mapFetch) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 8.0),
        Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            shadowColor: Colors.lightBlueAccent,
            child: _buildTableCalendarWithBuilders(mapFetch)),
        SizedBox(height: 15.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }
}
