import 'package:bloc_test/bloc_test.dart';
import 'package:ers_linux/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ers_linux/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthenticationEvent, AuthenticationState>
    implements AuthenticationBloc {}

void main(){
group('login tesing', (){
  testWidgets('Step 1 – renders all core UI widgets on LoginScreen', (WidgetTester tester) async {
    final mockBloc = MockAuthBloc();
    when(() => mockBloc.state).thenReturn(const LoginFormState());
    whenListen(mockBloc, Stream.value(const LoginFormState()));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthenticationBloc>.value(
          value: mockBloc,
          child: const LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login to your account'), findsOneWidget);
    // expect(find.byType(LoginBackground), findsOneWidget);
    // expect(find.byType(TextFieldCustom), findsNWidgets(2));
    // expect(find.widgetWithText(ButtonCustom, 'Login'), findsOneWidget);
    // expect(find.widgetWithText(ButtonCustom, 'Single Sign on'), findsOneWidget);
  });
});

}