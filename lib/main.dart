import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'splash.dart';
import 'homepage.dart';
import 'login/login.dart';
import 'login/about.dart';
import 'utils/colors.dart';
import 'login/register.dart';
import 'login/consent.dart';
import 'view/happiness/happiness_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Higeia',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('pt'),
      ],
      theme: ThemeData(
        primarySwatch: MyColors.greenSwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: MyColors.mainGreen,
        accentColor: Colors.white,
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.accent,
          buttonColor: MyColors.mainGreen,
        ),
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        primaryIconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: MyColors.mainGreen,
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.white,
        buttonColor: MyColors.mainGreen,
        fontFamily: "Montserrat",
        sliderTheme: SliderThemeData(
          valueIndicatorColor: MyColors.mainGreen,
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          //showValueIndicator: ShowValueIndicator.always,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      //initialRoute: "/splash",
      home: HappinessView(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/register': (BuildContext context) => RegisterScreen(),
        '/consent': (BuildContext context) => ConsentScreen(),
        '/home': (BuildContext context) => HomePage(),
        '/about': (BuildContext context) => About(),
      },
    );
  }
}
