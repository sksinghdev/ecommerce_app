// test/auth_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:common/presentation/bloc/auth_cubit.dart';
import 'package:common/presentation/bloc/auth_state.dart';
import 'package:common/data/models/user_model.dart';
import 'package:common/data/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    when(() => mockUser.phoneNumber).thenReturn('123');
    when(() => mockUser.email).thenReturn('test@email.com');
    when(() => mockUser.uid).thenReturn('il12om');
    when(() => mockUser.photoURL).thenReturn('htt');
    when(() => mockUser.displayName).thenReturn('santosh');
  });

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] when loginWithEmail succeeds',
      build: () {
        when(() => mockAuthRepository.signInWithEmail(
            'test@email.com', 'password')).thenAnswer((_) async => mockUser);
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.loginWithEmail('test@email.com', 'password'),
      expect: () => [
        AuthLoading(),
        isA<Authenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] when loginWithEmail fails',
      build: () {
        when(() => mockAuthRepository.signInWithEmail(any(), any()))
            .thenThrow(Exception('Login failed'));
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.loginWithEmail('fail@email.com', 'wrongpass'),
      expect: () => [
        AuthLoading(),
        isA<Unauthenticated>().having(
            (state) => state.message, 'message', contains('Login failed')),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Authenticated] when loginWithGoogle succeeds',
      build: () {
        when(() => mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => mockUser);
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.loginWithGoogle(),
      expect: () => [
        AuthLoading(),
        isA<Authenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, Unauthenticated] when loginWithGoogle fails',
      build: () {
        when(() => mockAuthRepository.signInWithGoogle())
            .thenThrow(Exception('Google sign-in failed'));
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.loginWithGoogle(),
      expect: () => [
        AuthLoading(),
        isA<Unauthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Unauthenticated] when logout is called',
      build: () {
        when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});
        return AuthCubit(mockAuthRepository);
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        Unauthenticated(),
      ],
    );
  });
}
