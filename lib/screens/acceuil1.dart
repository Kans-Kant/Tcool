import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Acceuil extends StatelessWidget {
  Acceuil({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff218faf),
      body: Stack(
        children: <Widget>[
          Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
              ]
          ),
          Transform.translate(
            offset: Offset(15.0, 266.0),
            child: Text(
              'Welcome Here to manage your Co-Ownership',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xffebebeb),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(131.0, 95.0),
            child:
                // Adobe XD layer: 'SUN SQUARE ALMAZ' (shape)
                Container(
              width: 112.5,
              height: 112.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/SUN SQUARE ALMAZ.jpg',),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(42.0, 349.0),
            child: Container(
              width: 291.0,
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(29.0),
                color: const Color(0xff12487d),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(159.0, 357.0),
            child: Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 22,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(42.0, 427.0),
            child: Container(
              width: 291.0,
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(29.0),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(142.0, 436.0),
            child: Text(
              'Register',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 22,
                color: const Color(0xff0943e4),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(61.0, 633.0),
            child: Text(
              'Arabe',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(131.5, 631.5),
            child: SvgPicture.string(
              _svg_com0e7,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(157.0, 631.0),
            child: Text(
              'Français',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(243.5, 629.5),
            child: SvgPicture.string(
              _svg_prmudn,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(269.0, 631.0),
            child: Text(
              'Anglais',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: 375.0,
            height: 667.0,
            child: Stack(
              children: <Widget>[
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(-978.0, -42.0, 1579.0, 819.0),
                  size: Size(375.0, 667.0),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  pinBottom: true,
                  child:
                      // Adobe XD layer: 'acceuil' (shape)
                      Container(decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('assets/acceuil.png'),
                          fit: BoxFit.fill,
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(0.05), BlendMode.dstIn),
                        ),
                      ),

                  ),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 667.0),
                  size: Size(375.0, 667.0),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  pinBottom: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x17ffffff),
                      border: Border.all(
                          width: 1.0, color: const Color(0x17707070)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_com0e7 =
    '<svg viewBox="131.5 631.5 1.0 28.0" ><path transform="translate(131.5, 631.5)" d="M 0 0 L 0 28" fill="none" stroke="#ffffff" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_prmudn =
    '<svg viewBox="243.5 629.5 1.0 24.0" ><path transform="translate(243.5, 629.5)" d="M 0 0 L 0 24" fill="none" stroke="#ffffff" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
