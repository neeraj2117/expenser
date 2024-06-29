import 'package:expensr/provider/user.dart';
import 'package:expensr/screens/login.dart';
import 'package:expensr/screens/onboard.dart';
import 'package:expensr/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Login.routeName,
      onGenerateRoute: generateRoute,
      home: OnboardScreen(),
    );
  }
}
