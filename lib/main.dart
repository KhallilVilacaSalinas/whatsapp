import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/app/RouteGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xff075E54), accentColor: Color(0xff25D366)),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute
      // routes: {
      //   '/': (context) => NotFound(),
      //   '/cadastro': (context) => CadastroPage(),
      //   '/home': (context) => Home()
      // },
      ));
}
