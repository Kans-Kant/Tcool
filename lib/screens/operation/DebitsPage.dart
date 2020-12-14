import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/OperationController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/operation/DetailsOperation.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import '../MainScreen.dart';
import 'AddOperation.dart';

class DebitsPage extends StatefulWidget {
  @override
  _DebitsPageState createState() => _DebitsPageState();
}

class _DebitsPageState extends State<DebitsPage> {
  List<Operation> operations = [];

  //--------------modify ------------
  String currentRole;
  String user;
  String role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    user = currentUser['username'];
    if (mounted) {
      this.setState(() {
        role = currentUser['authorities'][0]['authority'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          FutureBuilder(
              future: OperationController().getAllDebitsOperations(context),
              builder: (context, AsyncSnapshot<List<Operation>> snapshot) {
                if (!snapshot.hasData)
                  return Loading();
                if (snapshot.data.length == 0)
                  return Loading();
                operations.addAll(snapshot.data);
                double totalAmount = 0.0;
                for (int i = 0; i < operations.length; i++) {
                  totalAmount += operations[i].amount;
                }
                return Column(
                  children: <Widget>[
                    Align(
                        child: Text(
                      '${getTranslated(context, 'total')} : $totalAmount DH',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "mulish"),
                    )),
                    SizedBox(height: 40),
                    _debitsList(),
                  ],
                );
              }),
          SizedBox(height: 30),
              role == "ADMIN" ? _addOperationButton(): Container(),
          SizedBox(
            height: 30,
          ),
        ])));
  }

  /*Widget _addOperationButton() => InkWell(
        onTap: () => {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddOperationScreen()))
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: _gradian()),
          child: Center(
            child: Text(
              getTranslated(context, 'add_opr'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );*/

  Widget  _addOperationButton() => Container(
    //width: 300,
    height: 50,
    margin: EdgeInsets.symmetric(horizontal: 30),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        gradient: _gradian()
    ),
    child: MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          getTranslated(context, 'add_opr'),
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontFamily: "mulish",
          ),
        ),
      ),
      onPressed: () => {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddOperationScreen()))
      },
    ),
  );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/, LightColor.green1],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }


  ListView _debitsList() {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: operations.length,
        itemBuilder: (context, index) => Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: LightColor.white,
              shadowColor: LightColor.blueLinkedin,//LightColor.green,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: LightColor.blueLinkedin,//LightColor.green1,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text("${operations[index].title}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "mulish",
                        fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        DateFormat('dd-MM-yyyy')
                            .format(this.operations[index].createdDate),
                        style: TextStyle(fontFamily: "mulish")),
                    Text(
                        "${getTranslated(context, 'montant')}: ${operations[index].amount} ${getTranslated(context, 'dh')}",
                        style: TextStyle(fontFamily: "mulish")),
                  ],
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: LightColor.blueLinkedin,//LightColor.green1,
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => DetailsOperation(
                                operation: operations[index])))),
              ),
            ));
  }
}
