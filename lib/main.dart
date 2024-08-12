import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phsycho/screens/await/await.dart';
import 'firebase_options.dart';
import 'screens/mainScreen/mainpage.dart';
import 'screens/login/login.dart';
import "components/item/styles.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const PhsyCho());
}

class PhsyCho extends StatelessWidget {
  const PhsyCho({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
        initialRoute: Login.routename,
        routes: {
         Login.routename : (context)=> const Login(),
         Mainpage.routename:(context)=> Mainpage(),
         Await.routename: (context)=> Await(),
        },
      );
    }
  }






