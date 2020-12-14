import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcool_flutter/screens/AppBarWidget.dart';

class InterventionCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10,),
              IconButton(icon: Icon(Icons.notifications, color: Colors.white),iconSize: 60,
                
                onPressed: null),
              Text('Notifications'),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: SvgPicture.asset('assets/previous.svg'),
                    onPressed: (){}),
                  Text('1/3', style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),),
                  IconButton(
                    icon: SvgPicture.asset('assets/next.svg'),
                    onPressed: (){})
                  ],
                ),
              Text('Choisir une catégorie', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 10,),
              GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 2,
                crossAxisSpacing: 50,
                mainAxisSpacing: 20,
                padding: EdgeInsets.all(25),
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      print('Peinture');
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0,2),
                        )]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/peinture.svg',
                          color: Color(0xff006a71),),
                          SizedBox(height: 10,),
                          Text('Peinture, Sols et murs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0,2),
                        )]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/plomberie.svg',
                          color: Color(0xff006a71),),
                          SizedBox(height: 10,),
                          Text('Plomberie & Electricité',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0,2),
                        )]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/jardin.svg',
                          color: Color(0xff006a71),),
                          SizedBox(height: 10,),
                          Text('Jardins & Extérieur',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0,2),
                        )]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/autres.svg',
                          color: Color(0xff006a71),),
                          SizedBox(height: 10,),
                          Text('Autres travaux de copropriété',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    )
                  ),
                ],
              )
            ]
          )
        )
      ),
    );
  }
}
