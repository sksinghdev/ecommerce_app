

import 'package:common/common.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector.registerLazySingleton(() => FirebaseAuth.instance);
  injector.registerLazySingleton(() => GoogleSignIn());
}