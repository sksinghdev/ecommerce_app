import 'package:ecommerce_app/src/application/di/service_locator.dart';
import 'package:ecommerce_app/src/application/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'src/application/di/injection_container.dart' as di;
final _appRouter =  AppRouter();
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  
  await _registerDependencies();
  setupLocator();
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
    return  MaterialApp.router(routerConfig: _appRouter.config(),
   
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
    
    
    );
  }
}

