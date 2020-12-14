import 'dart:convert';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/InterventionController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Intervention.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/intervention/ImageScreen.dart';
import 'package:tcool_flutter/screens/intervention/SuivreIntervention.dart';
import 'package:tcool_flutter/screens/pages/DestinationScreen.dart';
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/pages/DestinationView.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import '../MainScreen.dart';

class DetailIntervention extends StatefulWidget {
  final Intervention intervention;
  final bool type;

  DetailIntervention({Key key, @required this.intervention, this.type}) : super(key: key);

  @override
  _DetailInterventionState createState() => _DetailInterventionState();
}

class _DetailInterventionState extends State<DetailIntervention> {
  Widget _content = CircularProgressIndicator();
  String currentRole;
  String currentuser;
  String _compte_rendu;
  String _note_intervention;
  final _scaffold = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  int nbrNotification = 0;
  String audioUrl;
  List<Compte> intervenants = List();
  Compte _selectedIndex = new Compte();
  AudioCache audioCache = AudioCache();

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
  }

  getCurrentUserEmail() async {
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    currentuser = "${currentUser['username']}";
    print(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: MyAppBar2(context),
      backgroundColor: LightColor.background,
      body: FutureBuilder(
          future: Utils.getCurrentRole(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return Center(child: _content);
            currentRole = snapshot.data;
            print(currentRole);
            return ListView(
              padding: EdgeInsets.all(15),
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: LightColor.white,
                    //border: Border.all(width: 1, color: LightColor.greyLinkedin/*Color(0xff006a71)*/),
                    borderRadius: BorderRadius.all(const Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: LightColor.blueLinkedin,
                        blurRadius: 5.0,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Align(
                      child: AppTitle(
                    getTranslated(context, 'det_inter'),
                  )),
                ),
                SizedBox(height: 30),
                Form(key: _formKey, child: _detailInterContainer()),
                SizedBox(height: 20),
                Visibility(
                    visible: (this.widget.intervention.status != "ANNULEE" && this.widget.intervention.status != "CLOTUREE") && Utils.isAdmin(currentRole) || Utils.isGestionnaire(currentRole),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        (this.widget.intervention.status == "VALIDER") && currentRole != "INTERVENANT"
                            ? _validerButton()
                            : this.widget.intervention.status == "AFFECTER"
                                ? _affecterButton()
                                : this.widget.intervention.status == "EN COURS"
                                    ? _evaluerButton()
                                    : this.widget.intervention.status == "EVALUER"
                                        ? _terminerButton()
                                        : Container(width: 0, height: 0),
                        this.widget.type && this.widget.intervention.status != "CLOTUREE" ? _refuserButton() : Container(width: 0, height: 0),
                        //   _backButton()
                      ],
                    ),
                    replacement: Utils.isIntervenant(currentRole) && widget.intervention.status == "EN COURS"
                        ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                            _evaluerButton(), // _backButton()
                          ])
                        : currentRole == "RESIDENT" && widget.intervention.status == "EVALUER" && this.widget.intervention.createdBy == currentuser
                            ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                                _terminerButton(),
                                // _backButton()
                              ])
                            : Container() //_backButton()
                    //_backButton(),
                    ),
              ],
            );
          }),
    );
  }

  //-----
  Widget _map() => Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.map, color: LightColor.blueLinkedin /*Color(0xff006a71)*/),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MapView(location: widget.intervention.location, latitude: widget.intervention.latitude, longitude: widget.intervention.longitude,)));
            },
          ),
          Text(getTranslated(context, 'conduire'),
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: LightColor.blueLinkedin, //Color(0xff006a71),
                  fontFamily: "mulish"))
        ],
      );

  Widget decorateTextField(Widget textfield) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(top: 15.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: LightColor.white,
        //border: Border.all(width: 1, color: LightColor.greyLinkedin/*Color(0xff006a71)*/),
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  Widget decorateText(Widget textfield) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      child: textfield,
    );
  }

  Widget decorateTextParagraph(Widget textfield) {
    return Container(
      width: 230,
      height: 100,
      margin: const EdgeInsets.only(top: 15.0, right: 30),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: LightColor.green,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: textfield,
    );
  }

  Widget _formLabel(String label) => Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
        ),
      );

  Widget _dateHourField(String dateHour) => TextFormField(
        keyboardType: TextInputType.text,
        initialValue: dateHour,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _titleField(String title) => TextFormField(
        initialValue: title,
        maxLengthEnforced: true,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _compteRenduField(String cr) => TextFormField(
        initialValue: cr,
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        decoration: new InputDecoration(border: InputBorder.none, hintText: getTranslated(context, 'rdg_cpt_rendu')),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'rdg_cpt_rendu');
          setState(() {
            _compte_rendu = value;
          });
          return null;
        },
      );

  Widget _compteRenduFieldRead(String cr) => TextFormField(
        initialValue: cr,
        readOnly: true,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: new InputDecoration(border: InputBorder.none, hintText: getTranslated(context, 'rdg_cpt_rendu')),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'rdg_cpt_rendu');
          setState(() {
            _compte_rendu = value;
          });
          return null;
        },
      );

//-------------------------------------------------------
  Widget _addNoteField(String cr) => TextFormField(
        initialValue: cr,
        keyboardType: TextInputType.multiline,
        maxLines: 10,
        decoration: new InputDecoration(border: InputBorder.none, hintText: getTranslated(context, 'note_inter')),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'note_inter');
          setState(() {
            _note_intervention = value;
          });
          return null;
        },
      );

  Widget _addNoteFieldRead(String cr) => TextFormField(
        initialValue: cr,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        readOnly: true,
        decoration: new InputDecoration(border: InputBorder.none, hintText: getTranslated(context, 'note_inter')),
      );

  Widget _detailField(String details) => TextFormField(
        initialValue: details,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _statusField(String status) => TextFormField(
        initialValue: status,
        maxLines: null,
        keyboardType: TextInputType.text,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );

  Widget _detailInterContainer() => Container(
        //TODO:: redesign the page
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: LightColor.white,
          //border: Border.all(width: 1, color: LightColor.greyLinkedin/*Color(0xff006a71)*/),
          borderRadius: BorderRadius.all(const Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: LightColor.blueLinkedin,
              blurRadius: 5.0,
              offset: Offset(0, 2),
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
                    Icon(Icons.event,color: LightColor.greyLinkedin,),
                    Expanded(
                      child:DetailTitle(
                          getTranslated(context, 'date_heure'),
                          DateFormat('dd/MM/yyyy - HH:mm:ss')
                              .format(widget.intervention.createdDate),MediaQuery.of(context).size.width * 0.37,),
                    ),
                  ]
              ),
            ),
            Divider(height: 2,color: Colors.black,),
            Container(
              child: Row(
                  children: <Widget>[
                    Icon(Icons.attachment,color: LightColor.greyLinkedin,),
                    Expanded(
                      child:DetailTitle(
                          getTranslated(context, 'theme'), widget.intervention.theme,MediaQuery.of(context).size.width * 0.37,),
                    ),
                  ]
              ),
            ),
            Divider(height: 2,color: Colors.black,),
            Container(
              child: Row(
                  children: <Widget>[
                    Icon(Icons.title,color: LightColor.greyLinkedin,),
                    Expanded(
                      child:DetailTitle(
                          getTranslated(context, 'titre'), widget.intervention.title,MediaQuery.of(context).size.width * 0.37,),
                    ),
                  ]
              ),
            ),
            Divider(height: 2,color: Colors.black,),
            Container(
              child: Row(children: <Widget>[
                Icon(
                  Icons.more_horiz,
                  color: LightColor.greyLinkedin,
                ),
                Expanded(
                  child: DetailTitleWidget(getTranslated(context, 'detail'), decorateText(_detailField(widget.intervention.details))),
                ),
              ]),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Container(
              child: Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/circle.svg",
                      color: widget.intervention.status =="VALIDER" ? Colors.green : LightColor.blueLinkedin,
                    ),
                    //Icon(Icons.circle,color: widget.intervention.status =="VALIDER" ? Colors.green : LightColor.blueLinkedin,),
                    Expanded(
                      child:DetailTitle(
                          getTranslated(context, 'status'), widget.intervention.status,MediaQuery.of(context).size.width * 0.37,),
                    ),
                  ]
              ),
            ),
            widget.intervention.intervenant != null ? DetailTitle(getTranslated(context, 'intervenant'),
              "${this.widget.intervention.intervenant.firstName} ${this.widget.intervention.intervenant.lastName}",
              MediaQuery.of(context).size.width * 0.37) : Container(),
            widget.intervention.intervenant != null
                ? DetailTitle(getTranslated(context, 'intervenant'),
                    "${this.widget.intervention.intervenant.firstName} ${this.widget.intervention.intervenant.lastName}",MediaQuery.of(context).size.width * 0.37,)
                : Container(),
            widget.intervention.intervenant != null ?  Divider(height: 2,color: Colors.black,) : Container(),
            Utils.isIntervenant(currentRole) &&
                    widget.intervention.status == "EN COURS"
                ? DetailTitleWidget(getTranslated(context, 'compt_rendu'),
                    decorateTextParagraph(_compteRenduField(null)))
                : Container(),
            Utils.isIntervenant(currentRole) &&
                    widget.intervention.status == "EN COURS"
                ? Divider()
                : Container(),
            Utils.isIntervenant(currentRole) && widget.intervention.status == "EN COURS" ? DetailTitleWidget(getTranslated(context, 'compt_rendu'), decorateTextParagraph(_compteRenduField(null))) : Container(),
            Utils.isIntervenant(currentRole) && widget.intervention.status == "EN COURS" ? Divider() : Container(),
            (widget.intervention.status == "EVALUER" && !Utils.isIntervenant(currentRole)) || widget.intervention.status == "CLOTUREE"
                ?
                //TODO:: Compte rendu read
                DetailTitleWidget(getTranslated(context, 'compt_rendu'), decorateText(_compteRenduFieldRead(widget.intervention.compteRendu)))
                : Container(),
            (widget.intervention.status == "EVALUER" && !Utils.isIntervenant(currentRole)) || widget.intervention.status == "CLOTUREE"
                ? Divider(
                    height: 2,
                    color: Colors.black,
                  )
                : Container(),
            // evaluate the intervention
            (widget.intervention.status == "EVALUER" && widget.intervention.createdBy == currentuser) ? DetailTitleWidget(getTranslated(context, 'noter'), decorateTextParagraph(_addNoteField(widget.intervention.evaluation))) : Container(),
            (widget.intervention.status == "EVALUER" && widget.intervention.createdBy == currentuser)
                ? Divider(
                    height: 2,
                    color: Colors.black,
                  )
                : Container(),
            // read the note add for the intervention
            widget.intervention.status == "CLOTUREE" ? DetailTitleWidget(getTranslated(context, 'noter'), decorateText(_addNoteFieldRead(widget.intervention.evaluation))) : Container(),
            widget.intervention.status == "CLOTUREE"
                ? Divider(
                    height: 2,
                    color: Colors.black,
                  )
                : Container(),
            //-----------------
            Divider(height: 2,color: Colors.black,),
            Container(
              child: Row(
                  children: <Widget>[
                    Icon(Icons.photo,color: LightColor.greyLinkedin,),
                    Expanded(
                      child:this.widget.intervention.images== null ? DetailTitle(
                          getTranslated(context, 'image'), "Pas d'image",MediaQuery.of(context).size.width * 0.37,) :DetailTitleWidget(getTranslated(context, 'image'), _imageButton()),
                    ),
                  ]
              ),
            ),
            Divider(height: 2,color: Colors.black,),
            Container(
              child: Row(
                  children: <Widget>[
                    Icon(Icons.audiotrack,color: LightColor.greyLinkedin,),
                    Expanded(
                      child:this.widget.intervention.audio== null ? DetailTitle(
                          getTranslated(context, 'audio'), "Pas d'audio",MediaQuery.of(context).size.width * 0.37,) : DetailTitleWidget(getTranslated(context, 'audio'), _audioButton()),
                    ),
                    SizedBox(height: 4,),
                  ]
              ),
            ),
            Divider(height: 2,color: Colors.black,),
            Container(
              child: Row(children: <Widget>[
                Icon(
                  Icons.add_location,
                  color: LightColor.greyLinkedin,
                ),
                Expanded(
                  child: DetailTitleWidget(getTranslated(context, 'emplacement'), decorateText(_statusField(widget.intervention.location))),
                ),
              ]),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            _map(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );

  Widget _validerButton() => InkWell(
        onTap: () => {_valider(widget.intervention)},
        //  Navigator.push(context, MaterialPageRoute(builder: (context) =>
        //    SuiviDiscussion(discussion: widget.discussion))),
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: LightColor.blueLinkedin, /*Color(0xff006a71)*/
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'valider'),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "mulish"),
            ),
          ),
        ),
      );

//------------------------------------------------
  Widget _affecterButton() => InkWell(
        onTap: () => {_affecter(widget.intervention)},
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: LightColor.blueLinkedin, /*Color(0xff006a71)*/
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'affecter'),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      );

  //---------------------------
  //fonction d'affection à un intervenant
  _affecter(Intervention i) {
    _showDialogForAffectation();
  }

  //--------------------------------
  _showDialogForAffectation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            getTranslated(context, 'select_inter'),
            style: TextStyle(fontSize: 14),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop('Annuler');
              },
              child: new Text(getTranslated(context, 'annuler')),
            ),
            new FlatButton(
              onPressed: () {
                InterventionController().updateIntervention(widget.intervention, context).whenComplete(() => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MainScreen(
                          currentPage: 2,
                        ))));
                // create a notification of the save
                notification.Notification notif = new notification.Notification();
                notif.isRead = false;
                notif.createdBy = widget.intervention.createdBy;
                notif.createdDate = new DateTime.now();
                notif.lastModifiedDate = new DateTime.now();
                notif.theme = "INTERVENTION";
                notif.message = "Nouvelle intervention affectée à vous: ${widget.intervention.title}";
                CompteController().sendNotificationToActeur(notif, widget.intervention.intervenant.idCompte, context);
              },
              child: new Text(getTranslated(context, 'accepter')),
            ),
          ],
          content: new SingleChildScrollView(child: Container(height: 200.0, width: 400.0, child: _dialogContent())),
        );
      },
    );
  }

//----------------------------------------
  Widget _dialogContent() {
    return Column(children: <Widget>[
      FutureBuilder(
          future: CompteController().getAllIntervenants(context),
          builder: (context, AsyncSnapshot<List<Compte>> snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            if (snapshot.data.length == 0) return Center(child: CircularProgressIndicator());
            List<Compte> intervenants = [];
            intervenants.addAll(snapshot.data);
            return Column(
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: intervenants.length,
                    itemBuilder: (context, index) => Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: LightColor.white,
                        shadowColor: LightColor.green,
                        child: ListTile(
                          title: Text("${intervenants[index].firstName} ${intervenants[index].lastName}", style: TextStyle(fontFamily: "mulish")),
                          onTap: () {
                            print(intervenants[index]);
                            setState(() {
                              widget.intervention.intervenant = intervenants[index];
                            });
                          },
                        )))
              ],
            );
          })
    ]);
  }

  //------------------------------------------------
  Widget _evaluerButton() => InkWell(
        onTap: () => {_evaluer(widget.intervention)},
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: LightColor.blueLinkedin, /*Color(0xff006a71)*/
          ),
          child: Center(
            child: Text(
              getTranslated(context, 'evaluer'),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      );

  //--------------------------
  _evaluer(Intervention i) {
    if (_formKey.currentState.validate()) {
      //i.compteRendu = _compte_rendu;
      InterventionController().evaluerIntervention(i, _compte_rendu, context).whenComplete(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SuivreIntervention(intervention: widget.intervention)));
      });
    }
  }

//-------------------------------------------------
  Widget _refuserButton() => InkWell(
        onTap: () => {_annuler(widget.intervention)},
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.blue[300]),
          child: Center(
            child: Text(
              getTranslated(context, 'refuser'),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "mulish"),
            ),
          ),
        ),
      );
//-------------------------------------------------
  Widget _terminerButton() => InkWell(
        onTap: () => {_terminer(widget.intervention)},
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.blue[300]),
          child: Center(
            child: Text(
              getTranslated(context, 'terminer'),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "mulish"),
            ),
          ),
        ),
      );
//-------------------------------------------------
  Widget _backButton() => InkWell(
        onTap: () => Navigator.of(context).pop(context),
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.indigo[300]),
          child: Center(
            child: Text(
              getTranslated(context, 'retour'),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "mulish"),
            ),
          ),
        ),
      );

  _terminer(Intervention i) async {
    if (_formKey.currentState.validate()) {
      //i.evaluation = _note_intervention;
      String _token = await storage.read(key: 'token');
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      InterventionController().cloturerStatus(i, _note_intervention, context).whenComplete(() {
        // create a notification of the save
        notification.Notification notif = new notification.Notification();
        notif.theme = "EVENEMENT";
        notif.isRead = false;
        notif.createdBy = currentUser['username'];
        notif.createdDate = new DateTime.now();
        notif.lastModifiedDate = new DateTime.now();
        notif.message = "l'intervention ${i.title} a été terminée";
        // notify the creator of the discussion
        CompteController().sendNotificationToActeurByEmmail(notif, i.createdBy, context).whenComplete(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MainScreen(
                    currentPage: 2,
                  )));
        });
        Utils.showAlertDialog(context, '${i.title} terminée !!');
      });
    }
  }

  _valider(Intervention i) async {
    InterventionController().validerStatus(i, context);
    // notify the creator of the intervention
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    notification.Notification notif = new notification.Notification();
    notif.createdDate = new DateTime.now();
    notif.createdBy = currentUser['username'];
    notif.lastModifiedDate = new DateTime.now();
    notif.message = "L'intervention ${i.title} a été validée";
    notif.isRead = false;
    notif.theme = "INTERVENTION";
    CompteController().sendNotificationToActeurByEmmail(notif, i.createdBy, context).whenComplete(() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainScreen(
                currentPage: 2,
              )));
    });
  }

  _annuler(Intervention i) async {
    String _token = await storage.read(key: 'token');
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    var response = await http.put(Constants.INTERVENTIONS + 'annuler-status/' + "${i.idIntervention}", headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      notification.Notification notif = new notification.Notification();
      notif.createdDate = new DateTime.now();
      notif.createdBy = currentUser['username'];
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "L'intervention ${i.title} a été annulée";
      notif.isRead = false;
      notif.theme = "INTERVENTION";
      // notify the creator of the intervention
      CompteController().sendNotificationToActeurByEmmail(notif, i.createdBy, context).whenComplete(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentPage: 2,
                )));
      });
      Utils.showAlertDialog(context, '${i.title} annulée !!');
      //
    } else {
      throw Exception('Erreur !!');
    }
  }

  //----------------------------------
  Widget _imagesLabel() => Text(
        getTranslated(context, 'image'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

  //----------------------------------
  Widget _audioLabel() => Text(
        getTranslated(context, 'audio'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 16,
        ),
      );

//--------------------------------
  Widget _intervenantLabel() => Text(
        getTranslated(context, 'intervenant'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "mulish",
          fontSize: 14,
        ),
      );
//----------------------------
  Widget _intervenantField(String intervenant) => TextFormField(
        keyboardType: TextInputType.text,
        initialValue: intervenant,
        readOnly: true,
        decoration: new InputDecoration(
          border: InputBorder.none,
        ),
      );
//----------------------------------
  Widget _audioButton() => InkWell(
        onTap: () => {_readAudio()},
        child: Container(
          width: 190,
          height: 35,
          //  margin: EdgeInsets.symmetric(horizontal: 50),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.grey[700],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset('assets/audio.svg'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  getTranslated(context, 'eco_audio'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "mulish",
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  //----------------------------------
  Widget _imageButton() => InkWell(
        onTap: () => {
          Navigator.of(this.context).push(MaterialPageRoute(
              builder: (context) => ImageScreen(
                    intervention: this.widget.intervention,
                  )))
        },
        child: Container(
          width: 190,
          height: 40,
          //   margin: EdgeInsets.symmetric(horizontal: 50),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.grey[700],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ImageIcon(
                  AssetImage('assets/image.png'),
                  size: 25,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  getTranslated(context, 'aff_img'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "mulish",
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  //---------------------------------------------------
  // audios functions
  void _readAudio() async {
    String audio_path = await InterventionController().downloadAudio(this.widget.intervention.audio, context);
    print(audio_path);
    AudioPlayer player = AudioPlayer();
    //var _recording = null;
    if (this.widget.intervention.audio != null) {
      //final result = OpenFile.open(audio_path);
      player.play(audio_path, isLocal: true);
      //player.play(audio_path, isLocal: true);
    } else {
      _scaffold.currentState.showSnackBar(Utils().showSnackBar(getTranslated(context, 'no_vocal_dispo')));
    }
  }
}
