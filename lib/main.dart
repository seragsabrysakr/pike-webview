import 'package:flutter/material.dart';
import 'package:picka/app/app_firebase.dart';
import 'package:picka/app/di/di.dart';
import 'package:picka/data/storage/local/app_prefs.dart';
import 'package:picka/pick_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  AppFirebase.initializeFireBase();

  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    getIt<AppPreferences>().firebaseToken = "سيشبتسشيبنتس بسنيبنم ";
    return const MaterialApp(
     debugShowCheckedModeBanner: false,
    home: PickScreen(),
    );
  }
}
