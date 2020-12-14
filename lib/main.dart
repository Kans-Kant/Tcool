import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tcool_flutter/localization/DemoLocalization.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  static void setLocale(BuildContext context, Locale locale){
        _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
        state.setLocale(locale);
  }

  static String getUserLocale(BuildContext context){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    print(state.getUserLocale());
    return state.getUserLocale().toString();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale ;
  
  void setLocale(Locale locale){
    setState(() {
      _locale = locale ;
    });
  }

  getUserLocale(){
    return this._locale;
  }

  @override
  void didChangeDependencies() {
    getLocale().then((value) {
      setState(() {
        this._locale = value ;
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Color(0xff006a71),
        primaryIconTheme:
            IconThemeData(color: Color(0xff006a71)),
      ),
      locale: _locale,
      supportedLocales: [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
        Locale('ar', 'AS'),
      ],
      localizationsDelegates: [
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode &&
              locale.countryCode == deviceLocale.countryCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first ;
      },
    );
  }
}
