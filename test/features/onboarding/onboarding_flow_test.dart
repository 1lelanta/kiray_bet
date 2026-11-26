import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/features/authentication/presentation/authentication_strings.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/login_screen.dart';
import 'package:kiray_bet/features/authentication/presentation/screens/splash_language_screen.dart';
import 'package:kiray_bet/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('completing onboarding opens language selection before login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: KirayBetApp()));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Get started'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.byType(SplashLanguageScreen), findsOneWidget);

    await tester.tap(find.text(AuthenticationStrings.continueLabel));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
