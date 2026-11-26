import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/constants/route_paths.dart';

void main() {
  test('listing route helpers encode IDs as one path segment', () {
    expect(RoutePaths.listingDetailPath('listing 1'), '/listings/listing%201');
    expect(
      RoutePaths.listingEditPath('listing/1'),
      '/listings/listing%2F1/edit',
    );
    expect(
      RoutePaths.requestViewingPath('listing?1'),
      '/viewing-requests/listing%3F1',
    );
  });
}
