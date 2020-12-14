import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tcool_flutter/controllers/EventController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Evenement.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/MainScreen.dart';
import 'package:tcool_flutter/screens/evenement/SuivreEvenement.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

class createEvent2 extends StatefulWidget {
  final int ref;
  createEvent2({Key key, this.ref}) : super(key: key);
  @override
  _createEvent2State createState() => _createEvent2State();
}

class _createEvent2State extends State<createEvent2> {

  Widget _content = CircularProgressIndicator();
  Evenement evenement;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context),
      backgroundColor: LightColor.white,//Color.fromARGB(255, 238, 238, 238),
      body: FutureBuilder(
          future: EventController().getEventById(this.widget.ref, context),
          builder: (context, AsyncSnapshot<Evenement> snapshot) {
            //  print(snapshot);
            if (!snapshot.hasData) return Loading();
            evenement = snapshot.data;
            print(evenement);
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    AppTitle(getTranslated(context, 'conf_demande')),
                    SizedBox(height: 50),
                    _middle(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _suivreButton(),
                        SizedBox(height: 5),
                        _eventsButton(),
                        SizedBox(height: 5),
                        _annulerButton()],
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            );
          }),
      //   bottomNavigationBar: bottomNav(2)
    );
  }

  //----------------------------------------
  Widget _leftRight() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              icon: SvgPicture.asset('assets/previous.svg',color: LightColor.blueLinkedin,), onPressed: () {}),
          Text(
            '2/2',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
              icon: SvgPicture.asset('assets/next.svg',color: LightColor.blueLinkedin,), onPressed: () {})
        ],
      );

  //----------------------------------------
  Widget _middle() => Column(
        children: <Widget>[
          SvgPicture.asset('assets/success.svg',color: LightColor.blueLinkedin,),
          SizedBox(
            height: 20,
          ),
          Text(
            getTranslated(context, 'event_succes'),
            style: TextStyle(
                color: LightColor.blueLinkedin,//Color(0xff006a71),
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '${getTranslated(context, 'ref')} : ${this.widget.ref}',
            style: TextStyle(
                color: LightColor.blueLinkedin,//Color(0xff006a71),
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      );

  //----------------------------------------
  Widget _twoButtons() => Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () => {},
              child: Container(
                height: 50,
                width: 100,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: LightColor.blueLinkedin,//Color(0xff006a71),
                ),
                child: Center(
                  child: Text(
                    getTranslated(context, 'suivre_event'),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "mulish",
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => {},
              child: Container(
                height: 50,
                width: 100,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.cyanAccent[700],
                ),
                child: Center(
                  child: Text(
                    getTranslated(context, 'list_event'),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "mulish",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  //----------------------------------------
  Widget _suivreButton()=>ButtonTheme(
      minWidth: 250.0,
      height: 45.0,
      child : RaisedButton(
        child: Text(getTranslated(context, 'suivre_event'),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: "mulish"),
        ),
        color: LightColor.blueLinkedin,
        padding: EdgeInsets.fromLTRB(10, 10, 5.0, 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SuivreEvenement(evenement: evenement)));
        },
      )
  );
  /*Widget _suivreButton() => InkWell(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SuivreEvenement(evenement: evenement)))
        },
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), color: Color(0xff006a71)),
          child: Center(
            child: Text(
              getTranslated(context, 'suivre_event'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );*/
//-------------------------------------------------
  Widget _eventsButton()=>ButtonTheme(
      minWidth: 250.0,
      height: 45.0,
      child : RaisedButton(
        child: Text(getTranslated(context, 'list_event'),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: "mulish"),
        ),
        color: LightColor.blueLinkedin,
        padding: EdgeInsets.fromLTRB(10, 10, 5.0, 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                    currentPage: 3,
                  )));
        },
      )
  );

  /*Widget _eventsButton() => InkWell(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(
                        currentPage: 3,
                      )))
        },
        child: Container(
          width: 100,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), color: Color(0xaa006a71)),
          child: Center(
            child: Text(
              getTranslated(context, 'list_event'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );*/

  //-----------------------------------------------

  Widget _annulerButton()=>ButtonTheme(
      minWidth: 250.0,
      height: 45.0,
      child : RaisedButton(
        child: Text(getTranslated(context, 'annul'),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: "mulish"),
        ),
        color: LightColor.greyLinkedin,//Color.fromARGB(175, 225, 0, 0),
        padding: EdgeInsets.fromLTRB(10, 10, 5.0, 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        onPressed: () {
          EventController().deleteEvenement(evenement, context).then(
                (value) =>  showAlertDialog(context),);
          }
          ),
  );

  /*Widget _annulerButton() => InkWell(
    onTap: () => {
      EventController().deleteEvenement(evenement, context).then((value) =>  showAlertDialog(context),),
    },
    child: Container(
      width: 100,
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7), color: Color(0xff006a71)),
      child: Center(
        child: Text(
          getTranslated(context, 'annul'),
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: "mulish"),
        ),
      ),
    ),
  );*/

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                  currentPage: 0,
                )));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Event"),
      content: Text("event canceled !!!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
