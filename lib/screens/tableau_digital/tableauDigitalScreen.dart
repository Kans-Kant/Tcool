import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CommunicationController.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/CoproprieteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Communication.dart';
import 'package:tcool_flutter/models/Compte.dart';
import 'package:tcool_flutter/models/Copropriete.dart';
import 'package:tcool_flutter/screens/tableau_digital/DetailCommunication.dart';
//import 'package:tcool_flutter/screens/communication/DetailEvent.dart';
//import 'package:tcool_flutter/screens/communication/Suivrecommunication.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';
import 'package:tcool_flutter/screens/widgets/rounded_button.dart';

import '../AppBarWidget2.dart';
import 'createCommunication.dart';


class TableauDigitalScreen extends StatefulWidget {
  @override
  _tableauDigitalScreenState createState() => _tableauDigitalScreenState();
}

// ignore: camel_case_types
class _tableauDigitalScreenState extends State<TableauDigitalScreen> {
  Widget progressIndicator = CircularProgressIndicator();

  List<Communication> filteredCommunications = new List<Communication>();

  //------------- update of rounded button
  bool ispressed1 = false;

  bool ispressed2 = false;

  Compte myAccount = new Compte();

  //---------------------- loading spinner
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //getUser();
    getAllCommunications();
  }

  getUser() async {
    Compte account;
    await CompteController().getCurrentAccount(context).then((value) => {
      /*this.setState(() {
         myAccount = value;
      }),*/
      account =value
    });
    return account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: LightColor.blueLinkedin,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateCommunication()));
        },
        child: Icon(Icons.add),
      ),
      body:Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                _communicationsBuilder(),
              ],
            )),
      ),
    );
  }

  //---------------------------------------------------------

  getCopropriete() async {
    Compte c = await getUser() as Compte;
    List<Copropriete> myCopropriets;
     await CoproprieteController().getAllCoproprietesbyCompte(c.idCompte,context).then((value) => {
      print("*****************************************"),
      /*this.setState(() {
        myCoproprietes = value;
      }),*/
      myCopropriets = value,
    }).whenComplete(() =>{print("Copropriete"), isLoading=false,})
         .catchError((e) {
       print("Got error:");
       setState(() {isLoading=false;});// Finally, callback fires.
     });

    return myCopropriets;
  }

  //-------------------- filtered buttons functions -----------------
  getMyCommunications() {
    if (mounted) {
      isLoading =true;
      CommunicationController()
          .getCommunicationsOfOwner(context)
          .then((value) {
        if (mounted) {
          setState(() {
            filteredCommunications = value;
          });
        }
      })
        ..whenComplete(() =>{print("Created by me"), isLoading=false,})
            .catchError((e) {
          print("Got error:");
          setState(() {isLoading=false;});// Finally, callback fires.
        });
    }
  }

  //----------------------------------------------------------

  getAllCommunications()  async {
    if (mounted) {
      isLoading = true;
       List<Copropriete> mycop;
       mycop=  await getCopropriete() as List;
       if(mycop.isNotEmpty) {
         isLoading = false;
         CommunicationController().getAllCommunication(
             mycop[0].idCopropriete, context).then((value) {
           List<Communication> val = value;
           print(val);
           if (mounted) {
             setState(() {
               filteredCommunications = value;
             });
           }
         }).whenComplete(() => {print("All"), isLoading = false,})
             .catchError((e) {
           print("Got error:"); // Finally, callback fires.
           setState(() {
             isLoading = false;
           });
         });
       }
       else {

         setState(() {
           isLoading = false;
         });
       }
     // });
    }
  }


  // intervention list
  //------------------------------------
  ListView communicationList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: (filteredCommunications.length + 1),
        itemBuilder: (context, index) =>
        index == 0 ? /*_searchBar()*/ Container() : _listItem(index - 1));
  }

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
                        builder: (context) =>  DetailCommunication(
                          communication: this.filteredCommunications[index],
                          type: true,
                        ))),
                    leading: CircleAvatar(
                      backgroundColor:  LightColor.blueLinkedin,//LightColor.green1,
                      child:Text("${index + 1}",
                        style: TextStyle(color: Colors.white),),
                    ),
                    title: Text(this.filteredCommunications[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "mulish",
                            fontSize: 14)),
                    subtitle: Text(
                        DateFormat('dd/MM/yyyy - HH:mm:ss')
                            .format(this.filteredCommunications[index].createdDate),
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
              /*onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Suivrecommunication(
                    communication: this.filteredEvents[index],
                  ))),*/
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
  Widget _communicationsBuilder() => Column(
    children: <Widget>[
      // filteredButton
      //-----------------
      isLoading ? const Loading() : Container(),
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
                  getAllCommunications();
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
                  getMyCommunications();
                  setState(() {
                    ispressed2 =false;
                    ispressed1 = true;
                  });
                }),
          ],
        ),
      ),
      //--------------------------------
      SizedBox(
        height: 10,
      ),
      Text(
        '${getTranslated(context, 'ncommunic')} : ${filteredCommunications.length}',
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
      communicationList()
    ],
  );

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
                  filteredCommunications /*= eventEnCours*/
                      .where(
                          (element) => element.title.toLowerCase().contains(text))
                      .toList();
                });
                print(filteredCommunications.length);
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

