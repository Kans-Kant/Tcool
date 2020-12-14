import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/EventController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Evenement.dart';
import 'package:tcool_flutter/screens/evenement/DetailEvent.dart';
import 'package:tcool_flutter/screens/evenement/SuivreEvenement.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';
import 'package:tcool_flutter/screens/widgets/rounded_button.dart';

class EventRejtee extends StatefulWidget {
  @override
  _EventRejteeState createState() => _EventRejteeState();
}

class _EventRejteeState extends State<EventRejtee> {
  Widget progressIndicator = CircularProgressIndicator();
  List<Evenement> eventsAnnulees = List();
  List<Evenement> filteredEvents = List();


  //------------- update of rounded button
  bool ispressed1 = false;

  bool ispressed2 = false;

  //-----------------loading spinner
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          _eventsBuilder(),
        ],
      )),
    );
  }

  //-------------------- filtered buttons functions -----------------
  getMyEvents() {

    if (mounted) {
      isLoading = true;
      EventController()
          .getEventsWithOwnerAndStatus(context, "REJETEE")
          .then((value) {
        if (mounted) {
          setState(() {
            eventsAnnulees = value;
            filteredEvents = eventsAnnulees;
          });
        }
      })
            ..whenComplete(() => {print("Created by me"),isLoading=false})
                .catchError((e) {
                  print("Got error:");
                  setState(() {isLoading=false;});// Finally, callback fires.
                });
    }
  }

  getAllEvents() {
    if (mounted) {
      isLoading = true;
      EventController().getAllEventsAnnulees(context).then((value) {
        if (mounted) {
          setState(() {
            eventsAnnulees = value;
            filteredEvents = eventsAnnulees;
          });
        }
      }).whenComplete(() => {print("All"), isLoading = false,})
          .catchError((e) {
            print("Got error:");
            if (mounted) {
              setState(() {
                isLoading = false;
              }); // Finally, callback fires.
            }
          });
    }
  }

  // intervention list
  //------------------------------------
  ListView eventsList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: (filteredEvents.length + 1),
        itemBuilder: (context, index) =>
            index == 0 ? /*_searchBar()*/ Container() : _listItem(index - 1));
  }

  //------------------------------
  _searchBar() {
    return Container(
        margin: EdgeInsets.all(10),
        padding: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          color: LightColor.lightGrey,
          border: Border.all(width: 2, color: LightColor.lightGrey),
          borderRadius: BorderRadius.all(const Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: LightColor.black,
              blurRadius: 5.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: getTranslated(context, 'Rech_titre'),
              //contentPadding: EdgeInsets.all(7.0)
            ),
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                filteredEvents = eventsAnnulees
                    .where(
                        (element) => element.title.toLowerCase().contains(text))
                    .toList();
              });
            }));
  }

  Widget _searchbar() =>Container(
    //color: Colors.green,
    height: 50,
    child: Row(
      children: <Widget>[
        Expanded(
          child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                hintText: getTranslated(context, 'Rech_titre_theme'),
                //contentPadding: EdgeInsets.all(8.0)
              ),
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() {
                  filteredEvents = eventsAnnulees
                      .where(
                          (element) => element.title.toLowerCase().contains(text))
                      .toList();
                });
                print(filteredEvents.length);
              }),
        ),
        Material(
          type: MaterialType.transparency,
          child: IconButton(
            splashColor: Colors.grey,
            icon: Icon(Icons.filter_list,size: 40,),
            onPressed: () {
              //Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ],
    ),
  );

  //---------------------------------------------
  /*_listItem(index) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: LightColor.white,
      shadowColor: LightColor.blueLinkedin,//LightColor.green,
      child: ListTile(
        onTap: () => {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailEvent(
                    evenement: this.filteredEvents[index],
                    type: false,
                  )))
        },
        leading: CircleAvatar(
          backgroundColor: LightColor.blueLinkedin,//LightColor.green1,
          child: Text(
            "${index + 1}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(this.filteredEvents[index].title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "mulish",
                fontSize: 14)),
        subtitle: Text(
            DateFormat('dd/MM/yyyy - HH:mm:ss')
                .format(this.filteredEvents[index].createdDate),
            style: TextStyle(fontFamily: "mulish")),
        trailing: IconButton(
            icon: Icon(
              Icons.history,
              color: LightColor.blueLinkedin,//LightColor.green1,
              size: 43.0,
            ),
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SuivreEvenement(
                          evenement: this.filteredEvents[index])))
                }),
      ),
    );
  }*/

  _listItem(index){
    return new Column(
      children:  <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child : Container(
                child: new Container(
                  //padding: new EdgeInsets.only(right: 8.0),
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>  DetailEvent(
                          evenement: this.filteredEvents[index],
                          type: true,
                        ))),
                    leading: CircleAvatar(
                      backgroundColor:  LightColor.blueLinkedin,//LightColor.green1,
                      child:Text("${index + 1}",
                        style: TextStyle(color: Colors.white),),
                    ),
                    title: Text(this.filteredEvents[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "mulish",
                            fontSize: 14)),
                    subtitle: Text(
                        DateFormat('dd/MM/yyyy - HH:mm:ss')
                            .format(this.filteredEvents[index].createdDate),
                        style: TextStyle(fontFamily: "mulish")),
                    /* trailing:*/ ),
                ),
              ),
            ),
            new Container(
              height: 40,
              width: 0.3,
              color: LightColor.greyLinkedin,
            ),
            //padding: new EdgeInsets.only(right: 8.0),
            new GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuivreEvenement(
                    evenement: this.filteredEvents[index],
                  ))),
              child : new Container(
                height: 60,
                width : 60,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(32.0),
                  //color: LightColor.blueLinkedin,
                  shape: BoxShape.rectangle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios, color:LightColor.blueLinkedin,//LightColor.green1
                  size: 30.0,),
              ),
            ),
          ],
        ),
        new Divider(
          color: Colors.grey,
          thickness: 1,
        )
      ],
    );
    // );
  }

  //------------------------------------
  Widget _eventsBuilder() => Column(
        children: <Widget>[
          //-----------------
          isLoading ? const Loading() : Container(),
          Column(
              children: <Widget>[
                _searchbar(),
                Divider(height: 6,color: Colors.black,)
              ]
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                RoundedButton(
                    text: getTranslated(context, 'filter_all'),
                    verticalPadding: 10,
                    fontSize: 14,
                    isPressed: ispressed2,
                    press: () {
                      getAllEvents();
                      setState(() {
                        ispressed2 =true;
                        ispressed1 = false;
                      });
                    }),
                SizedBox(
                  width: 20,
                ),
                RoundedButton(
                    text: getTranslated(context, 'filter_me'),
                    verticalPadding: 10,
                    fontSize: 14,
                    isPressed: ispressed1,
                    press: () {
                      getMyEvents();
                      setState(() {
                        ispressed2 =false;
                        ispressed1 = true;
                      });
                    }),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //--------------------------------
          Text(
            '${getTranslated(context, 'nbevent')} : ${filteredEvents.length}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "mulish",
            ),
          ),
          //     filterButtons(),
          SizedBox(
            height: 20,
          ),
          eventsList()
        ],
      );
}
