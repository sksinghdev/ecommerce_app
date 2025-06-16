import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing/presentation/bloc/product_cubit.dart';
import 'package:product_listing/presentation/widgets/product_list_widget.dart';

class MockProductCubit extends Mock implements ProductCubit {}

void main() {
  late MockProductCubit mockCubit;

  setUp(() {
    mockCubit = MockProductCubit();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<ProductCubit>.value(
        value: mockCubit,
        child: child,
      ),
    );
  }

  testWidgets('Shows shimmer loader on ProductInitial', (tester) async {
    when(() => mockCubit.state).thenReturn(ProductInitial());
    when(() => mockCubit.fetchInitialProducts()).thenAnswer((_) async {});
    whenListen(
        mockCubit, Stream<ProductState>.fromIterable([ProductInitial()]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductCubit>.value(
          value: mockCubit,
          child: const ProductListPage(),
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
