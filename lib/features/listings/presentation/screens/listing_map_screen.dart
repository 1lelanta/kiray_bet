import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_paths.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/listing.dart';
import '../listing_strings.dart';
import '../providers/listing_providers.dart';
import '../widgets/listing_card.dart';

class ListingMapScreen extends ConsumerStatefulWidget {
  const ListingMapScreen({super.key});
  @override
  ConsumerState<ListingMapScreen> createState() => _ListingMapScreenState();
}

class _ListingMapScreenState extends ConsumerState<ListingMapScreen> {
  String? _area;
  @override
  Widget build(BuildContext context) {
    final results = ref.watch(filteredListingsProvider);
    return AppScaffold(
      title: ListingStrings.map,
      body: results.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(child: Text(ListingStrings.error)),
        data: (all) {
          final listings = _area == null
              ? all
              : all.where((item) => item.subCity == _area).toList();
          return Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _area,
                decoration: const InputDecoration(
                  labelText: ListingStrings.selectedArea,
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(ListingStrings.any),
                  ),
                  ...ListingStrings.subCities.map(
                    (v) => DropdownMenuItem(value: v, child: Text(v)),
                  ),
                ],
                onChanged: (v) => setState(() => _area = v),
              ),
              SizedBox(
                height: 210,
                child: LayoutBuilder(
                  builder: (context, constraints) => GestureDetector(
                    onTapUp: (event) {
                      final hit = _nearest(
                        listings,
                        event.localPosition,
                        constraints.biggest,
                      );
                      if (hit != null) {
                        context.push(RoutePaths.listingDetailPath(hit.id));
                      }
                    },
                    child: CustomPaint(
                      size: constraints.biggest,
                      painter: _AddisMapPainter(listings),
                    ),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.my_location),
                label: const Text(ListingStrings.nearMeLater),
              ),
              Expanded(
                child: listings.isEmpty
                    ? const EmptyState(
                        icon: Icons.map_outlined,
                        title: ListingStrings.empty,
                      )
                    : ListView.builder(
                        itemCount: listings.length,
                        itemBuilder: (context, index) =>
                            ListingCard(listing: listings[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Listing? _nearest(List<Listing> listings, Offset tap, Size size) {
    if (listings.isEmpty) return null;
    Listing? best;
    var bestDistance = 20.0;
    for (final item in listings) {
      final point = _point(item, size);
      final distance = (tap - point).distance;
      if (distance < bestDistance) {
        bestDistance = distance;
        best = item;
      }
    }
    return best;
  }

  Offset _point(Listing item, Size size) => Offset(
    ((item.longitude - 38.67) / (38.88 - 38.67)) * size.width,
    size.height - ((item.latitude - 8.90) / (9.10 - 8.90)) * size.height,
  );
}

class _AddisMapPainter extends CustomPainter {
  _AddisMapPainter(this.listings);
  final List<Listing> listings;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEAF0ED),
    );
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 5;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 16), road);
    }
    for (final listing in listings) {
      final point = Offset(
        ((listing.longitude - 38.67) / .21) * size.width,
        size.height - ((listing.latitude - 8.90) / .20) * size.height,
      );
      canvas.drawCircle(point, 8, Paint()..color = const Color(0xFF2E7D68));
      canvas.drawCircle(point, 3, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _AddisMapPainter oldDelegate) =>
      oldDelegate.listings != listings;
}
