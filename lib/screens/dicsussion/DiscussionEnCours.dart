import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/DiscussionController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/dicsussion/SuivreDiscussion.dart';
import 'package:tcool_flutter/screens/dicsussion/detailDiscussion_v2.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';
import 'package:tcool_flutter/screens/widgets/rounded_button.dart';

class DiscussionEnCours extends StatefulWidget {
  @override
  _DiscussionEnCoursState createState() => _DiscussionEnCoursState();
}

class _DiscussionEnCoursState extends State<DiscussionEnCours> {
  Widget _content = CircularProgressIndicator();
  int nbr_discussion;
  List<Discussion> discussion_en_cours = List();
  List<Discussion> filteredDiscussions = List();

  bool ispressed1 = false;

  bool ispressed2 = false;

  //-------------------- loading spinner ----------------
  bool isLoading =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDiscuss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
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
                      getAllDiscuss();
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
                      getMyDiscuss();
                      setState(() {
                        ispressed2 =false;
                        ispressed1 = true;
                      });
                    }),
              ],
            ),
          ),
          //---------------------
          SizedBox(
            height: 5,
          ),
          Column(children: <Widget>[
            Text(
              "${getTranslated(context, 'nbdiscuss')} : ${filteredDiscussions.length}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "mulish",
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(padding: EdgeInsets.all(7), child: discussList())
          ])
        ],
      )),
    );
  }

  //-------------------- filtered buttons functions -----------------
  getMyDiscuss() {

    if (mounted) {
      isLoading =true;
      DiscussionController()
          .getDiscussionsInProgessOfOwner(context)
          .then((value) {
        if (mounted) {
          setState(() {
            discussion_en_cours = value;
            filteredDiscussions = discussion_en_cours;
          });
        }
      })
            ..whenComplete(() => {print("Created by me"),isLoading=false})
                .catchError((e) {
                  print("Got error:");
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                });
    }
  }

  getAllDiscuss() {
    isLoading =true;
    DiscussionController().getAllDiscussInProgress(context).then((value) {
      if (mounted) {
        setState(() {
          discussion_en_cours = value;
          filteredDiscussions = discussion_en_cours;
        });
      }
    }).whenComplete(() => {print("All"),isLoading=false})
        .catchError((e) {
          print("Got error:");
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
  }

  //-------------------------------------------------------------
  // discuss list
  //------------------------------------
  ListView discussList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: (filteredDiscussions.length + 1),
        itemBuilder: (context, index) =>
            index == 0 ? /*_searchbar()*/Container() : _listItem(index - 1));
  }

  //---------------------------------------------
  /*_listItem(index) {
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: LightColor.white,
        shadowColor: LightColor.blueLinkedin,//LightColor.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
            child : ListTile(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => detailDiscussion_v2(
                      discussion: this.filteredDiscussions[index],
                      type: true,
                    ))),
                leading: CircleAvatar(
                  backgroundColor:  LightColor.blueLinkedin,//LightColor.green1,
                  child:_themeIcon(index),
                  /*Text(
                "${index + 1}",
                style: TextStyle(color: Colors.white),
              ),*/
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    this.filteredDiscussions[index].theme != null
                        ? Text(
                      //this.filteredDiscussions[index].theme,
                      getTranslated(context, this.filteredDiscussions[index].theme),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "mulish",
                          fontSize: 14),
                    )
                        : Container(),
                    Text(
                      this.filteredDiscussions[index].title,
                      style: TextStyle(fontFamily: "mulish", fontSize: 14),
                    )
                  ],
                ),
                subtitle: Text(
                    DateFormat(
                      'dd/MM/yyyy - H:mm',
                    ).format(this.filteredDiscussions[index].createdDate),
                    style: TextStyle(fontFamily: "mulish")),
               /* trailing:*/ )
            ),
            Expanded(
                child:Container(
                  width: 25,
                  child:IconButton(
                    icon: Icon(
                      Icons.history, color: LightColor.blueLinkedin,//LightColor.green1,
                      size: 43.0,),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SuiviDiscussion(
                          discussion: this.filteredDiscussions[index],
                        ))),
                  ),
                ),
            )
          ],
        )
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
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => detailDiscussion_v2(
                          discussion: this.filteredDiscussions[index],
                          type: true,
                        ))),
                    leading: CircleAvatar(
                      backgroundColor:  LightColor.blueLinkedin,
                      child:_themeIcon(index),
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        this.filteredDiscussions[index].theme != null
                            ? Text(
                          getTranslated(context, this.filteredDiscussions[index].theme),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "mulish",
                              fontSize: 14),
                        )
                            : Container(),
                        Text(
                          this.filteredDiscussions[index].title,
                          style: TextStyle(fontFamily: "mulish", fontSize: 14),
                        )
                      ],
                    ),
                    subtitle: Text(
                        DateFormat(
                          'dd/MM/yyyy - H:mm',
                        ).format(this.filteredDiscussions[index].createdDate),
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
              new GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SuiviDiscussion(
                        discussion: this.filteredDiscussions[index],
                      ))),
                  child : new Container(
                    height: 60,
                    width : 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios, color:LightColor.blueLinkedin,
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

  //--------------------------new widget for Icon -------

  _themeIcon(int index){
    var theme = utf8.decode(this.filteredDiscussions[index].theme.runes.toList());

    if( getTranslated(context, theme)==getTranslated(context, "gestionnaire_rel") ){
      return SvgPicture.asset(
        'assets/relationSyndic.svg',
        color: Colors.white,//LightColor.green,
        width: 24,
      );
    }
    if( getTranslated(context, theme)==getTranslated(context, "hobbies"))  {

      return new SvgPicture.asset(
        'assets/ballon.svg',
        color: Colors.white,//LightColor.green,
        width: 24,
      );
    }
    if(getTranslated(context, theme)==getTranslated(context, "sujets")) {

      return new SvgPicture.asset(
        'assets/villeRegion.svg',
        color: Colors.white,//LightColor.green,
        width: 24,
      );
    }
    if(getTranslated(context, theme)==getTranslated(context, "autre_sujet")) {
      return new SvgPicture.asset(
        'assets/autreDiscussion.svg',
        color: Colors.white,//LightColor.green,
        width: 24,
      );
    }
    else
      return
        Text(
          "${index + 1}",
          style: TextStyle(color: Colors.white),
        );
  }

  //------------------------------
  /*_searchBar() {
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
              hintText: getTranslated(context, 'Rech_titre_theme'),
              //contentPadding: EdgeInsets.all(8.0)
            ),
            onChanged: (text) {
              text = text.toLowerCase();
              setState(() {
                filteredDiscussions = discussion_en_cours
                    .where((element) =>
                        (element.title.toLowerCase().contains(text) ||
                            element.theme.toLowerCase().contains(text)))
                    .toList();
              });
              print(filteredDiscussions.length);
            }));
  }*/

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
                  filteredDiscussions = discussion_en_cours
                      .where((element) =>
                  (element.title.toLowerCase().contains(text) ||
                      element.theme.toLowerCase().contains(text)))
                      .toList();
                });
                print(filteredDiscussions.length);
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
}
