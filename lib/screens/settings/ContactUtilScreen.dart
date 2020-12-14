import 'package:flutter/material.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/CoproprieteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Compte.dart';
import 'package:tcool_flutter/models/Copropriete.dart';
import 'package:tcool_flutter/screens/pages/Title.dart';
import 'package:tcool_flutter/screens/pages/detail_text.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import '../AppBarWidget4.dart';



class  ContactUtilScreen extends StatefulWidget {

  ContactUtilScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactUtilScreenState();

}

class _ContactUtilScreenState extends State<ContactUtilScreen> {

  Compte myAccount = new Compte();

  bool isLoading =false;

  Compte gestionnaire = new Compte();

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() {
    CompteController().getCurrentAccount(context).then((value) => {
      this.setState(() {
        myAccount = value;
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar4(context),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: this.gestionnaire ==null ? Container() : _utilsContainer(),
      ),
    );
  }

  //-----------------------------------------
  Widget _utilsContainer() => FutureBuilder(
  future: CoproprieteController().getAllCoproprietesbyCompte(myAccount.idCompte, context),
  builder: (context, AsyncSnapshot<List<Copropriete>> snapshot) {
    print(snapshot);
    if (!snapshot.hasData) return Loading();
    if(snapshot.hasError) return Container();
    List<Copropriete> mycops = new List<Copropriete>() ;
    mycops = snapshot.data;
    if(mycops.isNotEmpty){
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Align(
                  child: AppTitle(getTranslated(context, 'det_gest'),
                  )),),
            mycops.isEmpty ? Container() : Container(
              child: DetailTitle(getTranslated(context, 'username'),
                  mycops[0].gestionnaire.firstName+ mycops[0].gestionnaire.lastName, MediaQuery
                      .of(context)
                      .size
                      .width * 0.37),
            ),
            Container(
              height: 0.5,
              color: Colors.blue,
              margin: EdgeInsets.all(5.0),
            ),
            Container(
              child: DetailTitle(
                  getTranslated(context, 'mail'), mycops[0].gestionnaire.email, MediaQuery
                  .of(context)
                  .size
                  .width * 0.37),
            ),
            Container(
              height: 0.5,
              color: Colors.blue,
              margin: EdgeInsets.all(5.0),
            ),
            Container(
              child: DetailTitle(
                  getTranslated(context, 'telephone'), mycops[0].gestionnaire.phone,
                  MediaQuery
                      .of(context)
                      .size
                      .width * 0.37),
            ),
            Container(
              height: 0.5,
              color: Colors.blue,
              margin: EdgeInsets.all(5.0),
            ),
            Container(
              child: DetailTitle(
                  getTranslated(context, 'immeuble'), mycops[0].gestionnaire.immeuble,
                  MediaQuery
                      .of(context)
                      .size
                      .width * 0.37),
            ),
            Container(
              height: 0.5,
              color: Colors.blue,
              margin: EdgeInsets.all(5.0),
            ),
            Container(
              child: DetailTitle(
                  getTranslated(context, 'apart'), mycops[0].gestionnaire.appartement,
                  MediaQuery
                      .of(context)
                      .size
                      .width * 0.37),
            ),
            Container(
              height: 0.5,
              color: Colors.blue,
              margin: EdgeInsets.all(5.0),
            )
          ],
        ),
      );
    }
    else {
      return Container(
        child: Align(
          child: Text(
            getTranslated(context, 'contact_util'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }
  );
}
