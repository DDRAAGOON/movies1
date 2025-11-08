import 'package:flutter/material.dart';

import 'home/reset/reset_password.dart';
import 'home/utils/app_routes.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.resetPassRouteName,
        routes: {

          AppRoutes.resetPassRouteName : (context) => ResetPassword()


        },
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark()

    );
  }
}
