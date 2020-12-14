import 'package:flutter/material.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/compte/AddUser.dart';
import 'package:tcool_flutter/screens/compte/UserFile.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class UtilisateursScreen extends StatefulWidget {
  @override
  _UtilisateursScreenState createState() => _UtilisateursScreenState();
}

class _UtilisateursScreenState extends State<UtilisateursScreen> {
  List<Compte> accounts = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          FutureBuilder(
              future: CompteController().getAllAccounts(context),
              builder: (context, AsyncSnapshot<List<Compte>> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.data.length == 0)
                  return Center(child: CircularProgressIndicator());
                accounts.addAll(snapshot.data);
                return Column(
                  children: <Widget>[
                    Align(
                        child: Text(
                      '${getTranslated(context, 'nbr_users')} : ${accounts.length}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "mulish"),
                    )),
                    SizedBox(height: 40),
                    usersList(),
                  ],
                );
              }),
          SizedBox(height: 30),
          _addUserButton(),
          SizedBox(
            height: 30,
          ),
        ])));
  }

  //--------------------------------
  Widget _addUserButton() => InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddUser()));
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: _gradian()),
          child: Center(
            child: Text(
              getTranslated(context, 'add_user'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );

  //---------------------------------------
  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/, Colors.blue],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  //--------------------------------------
  ListView usersList() {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: accounts.length,
        itemBuilder: (context, index) => Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: LightColor.white,
              shadowColor: LightColor.blueLinkedin,//LightColor.green,
              child: ListTile(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserFile(compte: accounts[index])))
                },
                leading: CircleAvatar(
                  backgroundColor: LightColor.blueLinkedin,//LightColor.green1,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                    "${accounts[index].firstName} ${accounts[index].lastName}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "mulish",
                        fontSize: 14)),
                subtitle: Text("${accounts[index].myRoles[0].role}",
                    style: TextStyle(fontFamily: "mulish")),
                trailing: IconButton(
                    icon: Icon(
                      Icons.history,
                      color: LightColor.blueLinkedin,//LightColor.green1,
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                UserFile(compte: accounts[index])))),
              ),
            ));
  }
}
