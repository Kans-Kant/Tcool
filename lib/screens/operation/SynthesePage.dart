import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tcool_flutter/controllers/OperationController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/models/Amount.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';
import 'package:tcool_flutter/screens/widgets/loading.dart';

import '../Indicator.dart';

class SynthesePage extends StatefulWidget {
  @override
  _SynthesePageState createState() => _SynthesePageState();
}

class _SynthesePageState extends State<SynthesePage> {
  Amount amount = new Amount();
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: OperationController().getAllAmounts(context),
              builder: (context, AsyncSnapshot<Amount> snapshot) {
                if (!snapshot.hasData)
                  return const Loading();
                amount.creditAmount = snapshot.data.creditAmount;
                amount.debitAmount = snapshot.data.debitAmount;
                double balance = amount.creditAmount - amount.debitAmount; 
                return Column(
                  children: <Widget>[
                    Align(
                        child: Text(
                      balance > 0 ? 'Solde : + $balance ${getTranslated(context, 'dh')}' : 'Solde : $balance ${getTranslated(context, 'dh')}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "mulish"),
                    )),
                    SizedBox(height: 40),
                    Container(
                        width: 320,
                        height: 320,
                        padding: const EdgeInsets.all(15),
                        decoration: new BoxDecoration(
                          color: LightColor.lightGrey,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Align(
                                child: Text(
                             getTranslated(context, 'cat_op'),
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                            SizedBox(height: 20),
                            circulartChart(amount.debitAmount, amount.creditAmount)
                          ],
                        ))
                  ],
                );
              }),
        ));
  }

  Widget circulartChart(double a, double b) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        child: Row(
          children: <Widget>[
            SizedBox(height: 18),
            Expanded(
                child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse.touchInput is FlLongPressEnd ||
                          pieTouchResponse.touchInput is FlPanEnd) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse.touchedSectionIndex;
                      }
                    });
                  }),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: showingSections(a, b))),
            )),
            legend()
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(double debit, double credit) {
    return List.generate(2, (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;

      switch (index) {
        case 0:
          return PieChartSectionData(
              color: LightColor.blueLinkedin,//LightColor.green1,
              value: debit,
              title: '$debit ${getTranslated(context, 'dh')}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: LightColor.white,));
        //crédits
        case 1:
          return PieChartSectionData(
              color: LightColor.blue1,
              value: credit,
              title: '$credit ${getTranslated(context, 'dh')}',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black));
        default:
          return null;
      }
    });
  }

  Widget legend() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Indicator(text: getTranslated(context, 'debit'), isSquare: false, color: LightColor.blueLinkedin/*LightColor.green1*/,),
          SizedBox(height: 4),
          Indicator(text: getTranslated(context, 'credit'), isSquare: false, color: LightColor.blue1,)
        ],
      );
}
