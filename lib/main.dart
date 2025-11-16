import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_project/admin/admin_ui.dart';
import 'package:team_project/admin/controller/admin_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_)=>TabProvider(),
  child: const MyApp() ,)
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: AdminUi(),
    );
  }
}
