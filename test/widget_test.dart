import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/pages/login/login.dart';
import 'package:hefestus/ui/pages/login/signup.dart';
import 'package:hefestus/ui/pages/login/store_signup.dart';
import 'package:mockito/mockito.dart';
import 'package:hefestus/ui/widgets/map_page.dart';
import 'package:hefestus/ui/widgets/chat_page.dart';
import 'package:hefestus/ui/widgets/user_chat_page.dart';
import 'package:hefestus/ui/pages/content_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('LoginPage Tests', () {
    testWidgets('LoginPage should build its UI correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      // Verify the presence of certain widgets
      expect(find.text('Create user account'), findsOneWidget);
      expect(find.text('Create store account'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Navigates to SignUpPage when Create user account is pressed',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.byKey(const Key('SUA')));
      await tester.pumpAndSettle();

      expect(find.byType(SignUpPage), findsOneWidget);
    });

    testWidgets(
        'Navigates to StoreSignUpPage when Create store account is pressed',
        (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      await tester.tap(find.byKey(const Key('SSA')));
      await tester.pumpAndSettle();

      expect(find.byType(StoreSignUpPage), findsOneWidget);
    });

    testWidgets('ContentPage shows the correct page for each navbar tap',
        (WidgetTester tester) async {
      // Set up the test environment
      await tester.pumpWidget(
        GetMaterialApp(
          home: const ContentPage(),
        ),
      );

      // Initial state should show the first page
      expect(find.byType(MapPage), findsOneWidget);
      expect(find.byType(ChatPage), findsNothing);
      expect(find.byType(UserChatPage), findsNothing);

      // Tap the second navbar item (ChatPage)
      await tester.tap(find.byIcon(Icons.cabin));
      await tester.pumpAndSettle(); // Wait for animations to complete

      expect(find.byType(MapPage), findsNothing);
      expect(find.byType(ChatPage), findsOneWidget);
      expect(find.byType(UserChatPage), findsNothing);

      // Tap the third navbar item (UserChatPage)
      await tester.tap(find.byIcon(Icons.accessibility));
      await tester.pumpAndSettle(); // Wait for animations to complete

      expect(find.byType(MapPage), findsNothing);
      expect(find.byType(ChatPage), findsNothing);
      expect(find.byType(UserChatPage), findsOneWidget);
    });

    // Additional tests can be added here
  });
}
