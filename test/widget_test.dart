import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kiray_bet/app.dart';
import 'package:kiray_bet/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('app builds and shows the onboarding screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: KirayBetApp()));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
