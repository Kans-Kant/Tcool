import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

Widget bottomNav(int currentPage) {
  return BottomNavigationBar(
    currentIndex: currentPage,
        /*onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },*/
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
               icon: currentPage==0? SvgPicture.asset('assets/acceuil.svg',
                color: LightColor.blueLinkedin,//Color(0xff006a71),
              ): SvgPicture.asset('assets/acceuildesactive.svg'),
              title: Text('Accueil',
              style: TextStyle(fontFamily: "mulish",
                  color:currentPage==0? LightColor.blueLinkedin /*Color(0xff006a71)*/: Colors.grey[800]
                ))
            ),
          BottomNavigationBarItem( icon: currentPage==1? SvgPicture.asset('assets/discussion.svg',
                color:  LightColor.blueLinkedin/*Color(0xff006a71)*/,): SvgPicture.asset('assets/discussiondesactive.svg'),
              title: Text('Discussion',
              style: TextStyle(fontFamily: "mulish",
                  color: currentPage==1? LightColor.blueLinkedin/*Color(0xff006a71)*/: Colors.grey[800]
                ))
            ),
          BottomNavigationBarItem(
            icon: currentPage==2? ImageIcon(
                AssetImage('assets/intervention.png'),
                color:  LightColor.blueLinkedin/*Color(0xff006a71)*/,
                size: 36,
              ): ImageIcon(
                AssetImage('assets/interventiondesactive.png'), size: 36,),
              title: Text('Interventions',
              style: TextStyle(fontFamily: "mulish",
                  color: currentPage==2? LightColor.blueLinkedin/*Color(0xff006a71)*/: Colors.grey[800]
                ))
            ),
          BottomNavigationBarItem(
           icon: currentPage==3? ImageIcon(
                AssetImage('assets/evenement.png'),
                color:  LightColor.blueLinkedin/*Color(0xff006a71)*/,
                size: 36,
              ): ImageIcon(AssetImage('assets/eventdesactive.png'), size: 36,),
              title: Text('Evènements',
              style: TextStyle(fontFamily: "mulish",
                  color: currentPage==3? LightColor.blueLinkedin/*Color(0xff006a71)*/: Colors.grey[800]
                ))
            ),
          BottomNavigationBarItem(
             icon: currentPage==4?
                Icon(Icons.settings, color:  LightColor.blueLinkedin/*Color(0xff006a71)*/, size:36)
                : Icon(Icons.settings, color: Colors.grey, size:36),
              title: Text('Compte',
                style: TextStyle(fontFamily: "mulish",
                  color: currentPage==4? LightColor.blueLinkedin/*Color(0xff006a71)*/: Colors.grey[800]
                ),)
            ),
        ],
      );
}