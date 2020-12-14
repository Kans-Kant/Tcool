import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/resources/models.dart';


class MyDialogContent extends StatefulWidget {
  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  Compte _selectedIndex = new Compte();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FutureBuilder(
          future: CompteController().getAllIntervenants(context),
          builder: (context, AsyncSnapshot<List<Compte>> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.length == 0)
              return Center(child: CircularProgressIndicator());
            List<Compte> intervenants = [];
            intervenants.addAll(snapshot.data);
            return Column(
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: intervenants.length,
                    itemBuilder: (context, index) => RadioListTile<Compte>(
                          value: intervenants[index],
                          groupValue: _selectedIndex,
                          onChanged: (Compte value) {
                            print(value);
                            setState(() {
                              _selectedIndex = value;
                            });
                          },
                          title: Text(
                              "${intervenants[index].firstName} ${intervenants[index].lastName}"),
                        ))
              ],
            );
          })
    ]);
  }
}
