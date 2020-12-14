import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import '../AppBarWidget4.dart';


class  DetailNotificationPage extends StatefulWidget {


  @override
  _DetailNotificationPageState createState() => _DetailNotificationPageState();

}

class _DetailNotificationPageState extends State<DetailNotificationPage> {

  List<List<String>> items = List();
  List<Item> _questions;

  @override
  void initState() {
    super.initState();
    _questions =generateItems(8);
  }

  List<Item> generateItems(int numberOfItems) {
    List<Item> _questions = new List<Item>();
    _questions.add(
        new Item(
          headerValue: 'qr_1',
          expandedValue: 'rep_1',)
    );
    _questions.add(
        new Item(
          headerValue: 'qr_2',
          expandedValue: 'rep_2',)
    );
    _questions.add(
        new Item(
          headerValue: 'qr_3',
          expandedValue: 'rep_3',)
    );
    _questions.add(
        new Item(
          headerValue: 'qr_4',
          expandedValue: 'rep_4',)
    );
    _questions.add(
        new Item(
          headerValue: 'qr_5',
          expandedValue: 'rep_5',)
    );
    _questions.add(
        new Item(
          headerValue: 'qr_6',
          expandedValue: "rep_6",)
    );
    _questions.add(
        new Item(
          headerValue: 'qr_7',
          expandedValue: "rep_7",)
    );
    _questions.add(
        new Item(
          headerValue: 'qr_8',
          expandedValue: "rep_8",)
    );

    return _questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar4(context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 80),
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _questions[index].isExpanded = !isExpanded;
        });
      },
      children: _questions.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(getTranslated(context, item.headerValue),style: TextStyle(color: LightColor.blueLinkedin,fontSize: 18),),
            );
          },
          body: ListTile(
            title: Text(getTranslated(context, item.expandedValue)),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _listItem(index) {
    return new GestureDetector(
      onTap: () {
        _displayScreen(index);
        print(index);
      },
      child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                title: Text(
                  items[index][0],
                  style: TextStyle(fontSize: 18.0),
                ),
                trailing: Icon(Icons.arrow_forward_ios,size: 18,),
              ),
            ),
            Divider(color: Colors.grey,)
          ]
      ),
    );
  }

  _displayScreen(index){
    if(index==7){
    }
    if(index==2){

    }

  }

}

// stores ExpansionPanel state information
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
