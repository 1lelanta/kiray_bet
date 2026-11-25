import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/features/listings/presentation/screens/listings_screen.dart';
import 'package:kiray_bet/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('completing onboarding opens listings', (
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

    expect(find.byType(ListingsScreen), findsOneWidget);
  });
}
