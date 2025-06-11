import 'package:flutter/material.dart';

import 'src/application/di/injection_container.dart' as di;
import 'package:common/presentation/bloc/auth_cubit.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await _registerDependencies();
  runApp(const MyApp());
}

Future<void> _registerDependencies()async {
await di.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santi Bank',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Text('santi'),
    );
  }
}

