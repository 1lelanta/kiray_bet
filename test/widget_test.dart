import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kiray_bet/core/widgets/empty_state.dart';
import 'package:kiray_bet/main.dart';

void main() {
  testWidgets('app builds and shows the empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('No listings yet'), findsOneWidget);
  });
}
