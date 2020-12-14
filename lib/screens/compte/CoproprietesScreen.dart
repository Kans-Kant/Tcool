import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tcool_flutter/controllers/CoproprieteController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Copropriete.dart';
import 'package:tcool_flutter/screens/compte/AddCopropriete.dart';
import 'package:tcool_flutter/screens/compte/CoOwnershipFile.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class CoproprietesScren extends StatefulWidget {
  @override
  _CoproprietesScrenState createState() => _CoproprietesScrenState();
}

class _CoproprietesScrenState extends State<CoproprietesScren> {
  List<Copropriete> coproprietes = [];
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: CoproprieteController().getAllCoproprietes(context),
              builder: (context, AsyncSnapshot<List<Copropriete>> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.data.length == 0)
                  return Center(child: CircularProgressIndicator());
                coproprietes.addAll(snapshot.data);
                int nbrCop = coproprietes.length;
                return Column(
                  children: <Widget>[
                    Align(
                        child: Text(
                      '${getTranslated(context, 'nbr_cops')}: $nbrCop',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "mulish"),
                    )),
                    SizedBox(height: 20),
                    copropList(),
                  ],
                );
              }),
          SizedBox(height: 30),
          _addButton(),
          SizedBox(
            height: 30,
          ),
        ])));
  }

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.blueLinkedin/*LightColor.green*/, Colors.blue],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  //--------------------------------
  Widget _addButton() => InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddCopropriete()));
        },
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), gradient: _gradian()),
          child: Center(
            child: Text(
              getTranslated(context, 'add_cops'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );
  //--------------------------------------
  ListView copropList() {
    return ListView.builder(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: coproprietes.length,
        itemBuilder: (context, index) => Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: LightColor.white,
            shadowColor: LightColor.blueLinkedin,//LightColor.green,
            child: ListTile(
              onTap: () => {},
              leading: CircleAvatar(
                backgroundColor: LightColor.blueLinkedin,//LightColor.green1,
                child: Text(
                  "${index + 1}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text("${coproprietes[index].name}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "mulish",
                      fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      DateFormat('dd/MM/yyyy')
                          .format(this.coproprietes[index].createdDate),
                      style: TextStyle(fontFamily: "mulish", fontSize: 14)),
                  Text(
                      "${getTranslated(context, 'nb_res')}: ${coproprietes[index].nbResidents}",
                      style: TextStyle(fontFamily: "mulish", fontSize: 14)),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: LightColor.blueLinkedin,//LightColor.green1,
                  ),
                  onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CoOwnershipFile(
                                  copropriete: this.coproprietes[index],
                                )))
                      }),
            )));
  }
}
