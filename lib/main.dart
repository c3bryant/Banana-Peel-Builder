import 'package:bananapeel_eyeball/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'controllers/image_controller.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize services
  Get.put(ImageController());

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bananapeel Eyeball Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Black background for AppBar
          foregroundColor: Colors.white, // White text for AppBar
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
