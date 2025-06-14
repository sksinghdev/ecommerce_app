import 'package:authentication/core/injections/auth_router.dart';
import 'package:authentication/presentation/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:common/common.dart';
import 'package:auto_route/auto_route.dart';
import 'package:common/presentation/bloc/auth_cubit.dart';
import 'package:common/presentation/bloc/auth_state.dart';
 import 'package:bloc_test/bloc_test.dart';
class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class FakeRoute extends Fake implements StackRouter {}
final injector = GetIt.instance;
void main() {
  late MockAuthCubit mockAuthCubit;

  setUpAll(() {
     injector.registerFactory<AuthCubit>(() => mockAuthCubit); 
    registerFallbackValue(FakeAuthState());
    registerFallbackValue(FakeRoute()); 

    registerFallbackValue(Unauthenticated());
  });

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    if (injector.isRegistered<AuthCubit>()) {
      injector.unregister<AuthCubit>();
    }

    // Register the mock
    injector.registerFactory<AuthCubit>(() => mockAuthCubit);
  });
   tearDown(() async {
    await injector.reset();
  });


  testWidgets('shows CircularProgressIndicator when AuthLoading state',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthCubit.state).thenReturn(AuthLoading());

    // Act
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows login UI elements', (WidgetTester tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthInitial());

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email + Password
  });

  testWidgets('tapping Login button triggers email login',
      (WidgetTester tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthInitial());
    when(() => mockAuthCubit.loginWithEmail('test@email.com', 'password123')).thenAnswer((_) async {});

    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Enter email and password
    await tester.enterText(find.byType(TextFormField).at(0), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Tap login
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify that loginWithEmail was called
    verify(() => mockAuthCubit.loginWithEmail('test@email.com', 'password123')).called(1);
  });

  testWidgets('tapping Google Sign-In button triggers Google login',
    (WidgetTester tester) async {
  when(() => mockAuthCubit.state).thenReturn(AuthInitial());
  when(() => mockAuthCubit.loginWithGoogle()).thenAnswer((_) async {});

  await tester.pumpWidget(const MaterialApp(home: LoginPage()));

  await tester.tap(find.text('Sign in with Google'));
  await tester.pump();

  verify(() => mockAuthCubit.loginWithGoogle()).called(1);
});


  

  Widget _buildTestableWidget() {
    return MaterialApp.router(
      routerConfig: AuthRouter().config(), // Replace with your app router if needed
      builder: (context, child) => BlocProvider<AuthCubit>.value(
        value: mockAuthCubit,
        child: child!,
      ),
    );
  }

 
}
class FakeAuthState extends Fake implements AuthState {}
