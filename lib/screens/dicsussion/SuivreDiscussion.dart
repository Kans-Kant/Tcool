import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/controllers/DiscussionController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/resources/constants.dart';
import 'package:tcool_flutter/resources/models.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';
import 'package:tcool_flutter/screens/AppBarWidget2.dart';
import 'package:tcool_flutter/screens/NotifWidget.dart';
import 'package:http/http.dart' as http;
import 'package:tcool_flutter/models/Notification.dart' as notification;
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/bubble.dart';

import '../../models/Message.dart';
import '../MainScreen.dart';
import 'detailDiscussion_v2.dart';

class SuiviDiscussion extends StatefulWidget {
  final Discussion discussion;
  SuiviDiscussion({Key key, @required this.discussion}) : super(key: key);
  @override
  _SuiviDiscussionState createState() => _SuiviDiscussionState();
}

class _SuiviDiscussionState extends State<SuiviDiscussion> {
  int nbr_notification = 0;
  int _index = 0;
  String user;
  String role;
  final _formKey = GlobalKey<FormState>();
  final _scaffold = new GlobalKey<ScaffoldState>();
  final storage = FlutterSecureStorage();
  //List des messages
  List<Message> messages = [];
  String currentMsg;

  //update of chat
  String id ;
  final ScrollController listScrollController = ScrollController();

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool isEnable = false;
  Set groupSet = Set();

  Message prev;
  bool shownHeader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    this.messages.addAll(widget.discussion.msgDiscussions);
  }


  void scrollToBottom() {
    if (listScrollController.hasClients) {
      final bottomOffset = listScrollController.position.maxScrollExtent;
      listScrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 20),
      curve: Curves.easeInOut,
    );
    }
  }

  @override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }

  getCurrentUser() async {
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    user = currentUser['username'];
    role = currentUser['authorities'][0]['authority'];
    if(user !=null)
    setState(() {
      id=user;
    });
  }

  @override
  Widget build(BuildContext context) {
    scrollToBottom();
    return Scaffold(
      appBar: MyAppBar2(context),
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      body: Column(
          children: <Widget>[
            Expanded(
                child:SingleChildScrollView(
                  child: Column(children: <Widget>[
                Theme(
                    data: ThemeData(
                      primaryColor: LightColor.blueLinkedin,//Color(0xff006a71),
                    ),
                    child: _tabStep()
                ),
                Container(
                  child: _discussContent(),
                ),
              ]),
                ),
            ),
            Container(
              child: Form(key: _formKey, child: buildInput()),)
          ]
      ),
    );
  }

  //---------------------------------------
  Widget _tabStep() => Container(
      //margin: EdgeInsets.only(top: 10),
      color: Color.fromARGB(12, 12, 13, 15),
      constraints: BoxConstraints.expand(height: 150),
      child: Stepper(
        physics: ClampingScrollPhysics(),
        type: StepperType.horizontal,
        steps: [
          Step(
            isActive: true,
            title: _index == 0 ? Column(children: [
              SvgPicture.asset('assets/creation.svg',color: LightColor.blueLinkedin,height: 15,),
              SizedBox(
                height: 4,
              ),
              Text(getTranslated(context, 'creation'),
                  style: TextStyle(color: LightColor.blueLinkedin/*Color(0xff006a71)*/))
            ]) : Text(''),
            content: Text(
              "La discussion est créée le ${DateFormat('dd/MM/yyyy - H:mm').format(widget.discussion.createdDate)}",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Step(
            isActive: true,
            title: _index == 1 ? Column(children: [
              SvgPicture.asset('assets/validation.svg',color: LightColor.blueLinkedin,height: 15,),
              SizedBox(
                height: 4,
              ),
              Text(getTranslated(context, 'valid'),
                  style: TextStyle(color: LightColor.blueLinkedin/*Color(0xff006a71)*/))
            ]) : Text(''),
            content: Text(
                "Le statut de la discussion est: ${widget.discussion.status}"),
          ),
          /*Step(
              isActive: true,
              title: Column(children: [
                SvgPicture.asset('assets/discuss.svg',width: 10,),
                SizedBox(
                  height: 3,
                ),
                Text(getTranslated(context, 'discuss'),
                    style: TextStyle(color: Color(0xff006a71)))
              ]),
              content: _discussContent()),*/
          Step(
            isActive: false,
            title: _index == 2 ? Column(children: [
              SvgPicture.asset('assets/cloture.svg',height: 15,),
              SizedBox(
                height: 4,
              ),
              Text(getTranslated(context, 'cloture'))
            ]) : Text(""),
            content: widget.discussion.status == "EN COURS" &&
                    (role == "ADMIN" || user == widget.discussion.createdBy)
                ? _validerButton()
                : Text(''),
          ),
        ],
        currentStep: _index,
        onStepTapped: (index) {
          setState(() {
            _index = index;
          });
        },
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Row(
            children: <Widget>[
              Container(
                child: null,
              ),
              Container(
                child: null,
              )
            ],
          );
        },
      ),
  );

  //--------------------------------------
  Widget _discussContent() => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _ficheButton(),
          SizedBox(height: 10),
          Container(
              //width: 360,
              height: 550,
              margin: EdgeInsets.all(20) ,
              decoration: BoxDecoration(
                  //borderRadius: BorderRadius.all(const Radius.circular(10)),
                  /*gradient: _gradian()*/),
              child: _messagesList1()),
          SizedBox(height: 10),
          //Form(key: _formKey, child: _addComment()),
          //SizedBox(height: 10),
          //Container(width: 300, child: _discussGroupBtn()),
        ],
      );

  // ---------------------------------------
  LinearGradient _gradian() {
    return new LinearGradient(
        colors: [LightColor.lightGrey, LightColor.grey],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp);
  }

  //--------------------------------------
  Widget _ficheButton() => InkWell(
        //onTap: () => Navigator.of(context).pop(),
    onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => detailDiscussion_v2(
          discussion: widget.discussion,
          type: true,
        ))),
        child: Container(
          width: 300,
          height: 50,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(const Radius.circular(10)),
              color: LightColor.blueLinkedin,/*LightColor.green1*/),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                getTranslated(context, 'fiche_discuss'),
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Sriracha', fontSize: 16),
              ),
              Icon(
                Icons.insert_drive_file,
                color: Colors.white,
                size: 30,
              )
            ],
          ),
        ),
      );

  //----------------------------------------
  Widget _addBtn() => InkWell(
        onTap: () {
          ajouter();
        },
        child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: LightColor.blueLinkedin,//Color(0xff006a71),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
              child: Text(getTranslated(context, 'ajouter'),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sriracha',
                      fontSize: 16))),
        ),
      );

  //----------------------------------------
  Widget _deleteBtn() => InkWell(
        onTap: () {
          supprimer();
        },
        child: Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
              child: Text(getTranslated(context, 'supprimer'),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Sriracha',
                      fontSize: 16))),
        ),
      );

  //-----------------------------------
  Widget _discussGroupBtn() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_addBtn(), _deleteBtn()],
      );

  //------------------------------------------
  Widget _addComment() {
    return Container(
      width: 300,
      height: 60,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(const Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: LightColor.blueLinkedin,//LightColor.green,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: getTranslated(context, 'commentaire')),
        validator: (value) {
          if (value.isEmpty) return getTranslated(context, 'sais_comm');
          setState(() {
            currentMsg = value;
          });
          return null;
        },
      ),
    );
  }

  //------------------------
  void ajouter() async {
    if (_formKey.currentState.validate()) {
      Map currentUser = json.decode(await storage.read(key: 'currentUser'));
      Message newMsg = Message();
      getMessage();
      newMsg.message = currentMsg;
      newMsg.createdDate = new DateTime.now();
      newMsg.lastModifiedDate = new DateTime.now();
      newMsg.createdBy = currentUser['username'];
      messages.add(newMsg);
      _formKey.currentState.reset();
      widget.discussion.msgDiscussions = messages;
      widget.discussion.lastModifiedDate = new DateTime.now();
      widget.discussion.lastModifiedBy = currentUser['username'];
      // save the current message and update the discussion in the DB

      DiscussionController()
          .addMessage(newMsg, widget.discussion.idDiscussion, context);
    } else {
      Utils.showAlertDialog(context, getTranslated(context, 'sais_comm'));
    }
    scrollToBottom();
  }

  void getMessage() {
    this.setState(() {
      currentMsg = textEditingController.text;
    });
    textEditingController.clear();
    isEnable = false;
  }

  void supprimer() {
    _formKey.currentState.reset();
  }

  //---------------------------------------
  ListView _messagesList1(){
    Message prev;
    bool shownHeader = false;

    int index = 0;

    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

    List<Widget> _listChildren = <Widget>[];
    messages.forEach((Message message) {
      if (prev != null && _dateFormat.format(message.createdDate) != _dateFormat.format(prev.createdDate)) {
        shownHeader = false; // if dates are different, beginning of a new group, so header is yet to be shown
      }

      if (!shownHeader) {
        // if header for a group is not shown yet, add it to the list
        _listChildren.add(
            ListTile(
            title:
            Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    _dateFormat.format(message.createdDate).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: "mulish",
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ));
        this.setState(() {
          prev = message; // keep the current model for reference to check if group has changed
        });
        shownHeader = true;
      }
      _listChildren.add(buildItem(index, message));
      index= index+1;
    });

    return ListView(
      children: _listChildren,
      reverse: false,
      controller: listScrollController,
    );

  }

  ListView _messagesList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),

      itemCount: messages.length,
      reverse: false,
      controller: listScrollController,
      itemBuilder: (context, index) => buildItem(index, messages[index]),
      /*itemBuilder: (context, index) => Column(children: <Widget>[
        Container(
          width: 230,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(width: 1, color: LightColor.green),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Text(messages[index].message),
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Text(messages[index].createdBy.toString() +
                ' ' +
                DateFormat('dd/MM/yyyy - H:mm')
                    .format(messages[index].createdDate)))
      ]),*/
    );
  }

  //**************** Item Builder ************
  Widget buildItem(int index, Message message) {
    return
          Container(
            child: Bubble(
              username: message.createdBy,
              message: message.message,
              time: '${message.createdDate.hour}'+":"+'${message.createdDate.minute}',
              delivered: false,
              isMe: message.createdBy == id ? true : false,
            ),
          );

    /*if (message.createdBy == id) {
      return Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Center(
                child: Text(
                  messages[index].createdBy.toString() +' - '+
                  DateFormat('dd MMM kk:mm').format(
                      message.createdDate),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic),),
              ),
              Container(
                child: Text(
                  message.message,
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: LightColor.blueLinkedin,//LightColor.green,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(
                    bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                    right: 10.0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            // Time
            Container(
              child: Text(
            messages[index].createdBy.toString() +' - '+DateFormat('dd MMM kk:mm').format(
                    message.createdDate),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
            ),
            Container(
              child: Text(
                message.message,
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Color.fromARGB(150, 0, 0, 0),
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(
                  bottom: isLastMessageLeft(index) ? 5.0 : 10.0,
                  right: 10.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }*/
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        messages != null &&
        messages[index - 1].createdBy== id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        messages != null &&
        messages[index - 1].createdBy  != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

//--------------------------------------------
  Widget _validerButton() => InkWell(
        onTap: () => {_valider(widget.discussion)},
        child: Container(
          width: 90,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: LightColor.blueLinkedin,/*Color(0xff006a71)*/),
          child: Center(
            child: Text(
              getTranslated(context, 'cloturer'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: "mulish"),
            ),
          ),
        ),
      );
  //------------------------------------
  _valider(Discussion i) async {
    String _token = await storage.read(key: 'token');
    i.lastModifiedDate = new DateTime.now();
    Map currentUser = json.decode(await storage.read(key: 'currentUser'));
    var response = await http.put(
        Constants.DISCUSSISONS + 'cloturer-status/' + "${i.idDiscussion}",
        headers: {"Authorization": "Bearer $_token"});
    if (response.statusCode == 200) {
      notification.Notification notif = new notification.Notification();
      notif.createdDate = new DateTime.now();
      notif.createdBy = currentUser['username'];
      notif.lastModifiedDate = new DateTime.now();
      notif.message = "La discusstion ${i.title} a été cloturée";
      notif.isRead = false;
      notif.theme = "DISCUSSION";
      // notify the creator of the discussion
      CompteController()
          .sendNotificationToActeurByEmmail(notif, i.createdBy, context)
          .whenComplete(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentPage: 1,
                )));
      });
      Utils.showAlertDialog(context, '${i.title} validée !!');
    } else {
      throw Exception('Erreur !!');
    }
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(width: 4,),
          // Button send image
          /*Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () => {},
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: () => {},
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),*/

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                 // addPost(textEditingController.text);
                },
                onChanged: (val) {
                  if(textEditingController.text.isNotEmpty){
                    setState(() {
                      isEnable= true;
                    });
                  }
                  else{
                    setState(() {
                      isEnable= false;
                    });
                  }
                },
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => {
                  if(isEnable){
                    //addPost(textEditingController.text),
                    ajouter(),
                  }
                },
                color: isEnable ? LightColor.blueLinkedin : Colors.grey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }
  bool showHeader(int index){

    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

    if (prev != null && _dateFormat.format(messages[index].createdDate) != _dateFormat.format(prev.createdDate)) {
      setState(() {
        shownHeader = false;
      });// if dates are different, beginning of a new group, so header is yet to be shown
    }

    if (!shownHeader) {
      // if header for a group is not shown yet, add it to the list
      setState(() {
        prev = messages[index]; // keep the current model for reference to check if group has changed
        shownHeader = true;
      });
    }

    return shownHeader;

  }
}


