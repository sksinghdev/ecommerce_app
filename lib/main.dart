import 'package:ecommerce_app/src/application/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/application/di/injection_container.dart' as di;
final _appRouter =  AppRouter();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
   try {
      return MaterialApp.router(
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    } catch (e, stack) {
      debugPrint('Error during router initialization: $e\n$stack');
      return const MaterialApp(home: Scaffold(body: Center(child: Text('App initialization failed'))));
    }
  }
}

