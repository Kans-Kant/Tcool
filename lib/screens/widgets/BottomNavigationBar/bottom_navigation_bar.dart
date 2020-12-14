import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tcool_flutter/controllers/CompteController.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

import 'bottom_curved_painter.dart';

import 'package:tcool_flutter/models/Notification.dart' as notif ;


class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onIconPresedCallback;
  int selectedIndex;
  CustomBottomNavigationBar({Key key, this.onIconPresedCallback , this.selectedIndex})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  //int _selectedIndex = 0;

  AnimationController _xController;
  AnimationController _yController;
  @override
  void initState() {
    _xController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController.value =
        _indexToPosition(widget.selectedIndex) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;

    super.didChangeDependencies();
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    const buttonCount = 5.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / buttonCount +
        buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  //************************ big Modification here **************************
  Widget _icon(IconData icon, bool isEnable, int index, int snap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        onTap: () {
          _handlePressed(index);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          alignment: isEnable ? Alignment.topCenter : Alignment.center,
          child: AnimatedContainer(
              height: isEnable ? 40 : 20,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isEnable ?  LightColor.blueLinkedin /*LightColor.green1*/ : Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: isEnable ? Color(0xfffeece2) : Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(5, 5),
                    ),
                  ],
                  shape: BoxShape.circle),
              child: Opacity(
                opacity: isEnable ? _yController.value : 1,
                /*child: Icon(icon,
                    color: isEnable
                        ?  LightColor.background
                        : Theme.of(context).iconTheme.color),*/
                child :new Stack(
                    children: <Widget>[
                      new Icon(icon),
                      new Positioned(  // draw a red marble
                        top: 1.0,
                        right: 1.0,
                        child: snap > 0 ?new Container(
                          //margin: const EdgeInsets.all(2.0),
                          padding: const EdgeInsets.all(2.0),

                          decoration: BoxDecoration(
                             // border: Border.all(color: Colors.white)
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text('$snap',
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w800)),
                        ): new Container(),
                      )
                    ]
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController.value),
            end: inCurve.transform(_yController.value),
          ).transform(_yController.velocity.sign * 0.5 + 0.5),
          LightColor.lightGrey),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (widget.selectedIndex == index || _xController.isAnimating) return;
    widget.onIconPresedCallback(index);
    setState(() {
      widget.selectedIndex = index;
    });
    _yController.value = 1.0;

    _xController.animateTo(
         _indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _yController.animateTo(1.0, duration: Duration(milliseconds: 1200));
      },
    );
    _yController.animateTo(0.0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final height = 60.0;
    return Container(
      width: appSize.width,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: appSize.width,
            height: height - 10,
            child: _buildBackground(),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _icon(Icons.home, widget.selectedIndex == 0, 0,0),
                _icon(Icons.forum, widget.selectedIndex == 1, 1,0),
                _icon(Icons.build, widget.selectedIndex == 2, 2,0),
                _icon(Icons.event, widget.selectedIndex == 3, 3,0),
                //_icon(Icons.notifications, widget.selectedIndex == 4, 4,4),

                FutureBuilder(
                    future: CompteController().getAllUnreadNotification(context),
                    builder: (context, AsyncSnapshot<List<notif.Notification>> snapshot) {
                      if (!snapshot.hasData) return _icon(Icons.notifications, widget.selectedIndex == 4, 4,0);
                      //if(snapshot.data.length == 0) return body(context, _temp, 0);
                      int number = snapshot.data.length;
                      return _icon(Icons.notifications, widget.selectedIndex == 4, 4,snapshot.data.length);
                    }
                )
                //_icon(Icons.notifications, widget.selectedIndex == 4, 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}