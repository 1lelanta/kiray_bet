import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../domain/listing_filter.dart';
import '../listing_strings.dart';
import '../providers/listing_providers.dart';

class ListingFilterScreen extends ConsumerStatefulWidget {
  const ListingFilterScreen({super.key});

  @override
  ConsumerState<ListingFilterScreen> createState() =>
      _ListingFilterScreenState();
}

class _ListingFilterScreenState extends ConsumerState<ListingFilterScreen> {
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _neighbourhoodController = TextEditingController();
  String? _subCity;
  int? _bedrooms;
  ListingSortOrder _sort = ListingSortOrder.newest;
  final Set<String> _amenities = {};

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    _neighbourhoodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const subCities = [
      'Bole',
      'Yeka',
      'Kirkos',
      'Lideta',
      'Arada',
      'Nifas Silk-Lafto',
      'Kolfe Keranio',
      'Gullele',
    ];
    return AppScaffold(
      title: ListingStrings.filter,
      body: ListView(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _subCity,
            decoration: const InputDecoration(
              labelText: ListingStrings.subCity,
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text(ListingStrings.any),
              ),
              ...subCities.map(
                (value) => DropdownMenuItem(value: value, child: Text(value)),
              ),
            ],
            onChanged: (value) => setState(() => _subCity = value),
          ),
          TextField(
            controller: _neighbourhoodController,
            decoration: const InputDecoration(
              labelText: ListingStrings.neighbourhood,
            ),
          ),
          TextField(
            controller: _minController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: ListingStrings.minRent,
            ),
          ),
          TextField(
            controller: _maxController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: ListingStrings.maxRent,
            ),
          ),
          DropdownButtonFormField<int>(
            initialValue: _bedrooms,
            decoration: const InputDecoration(
              labelText: ListingStrings.bedrooms,
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text(ListingStrings.any),
              ),
              for (var i = 1; i <= 4; i++)
                DropdownMenuItem(value: i, child: Text('$i+')),
            ],
            onChanged: (value) => setState(() => _bedrooms = value),
          ),
          DropdownButtonFormField<ListingSortOrder>(
            initialValue: _sort,
            items: const [
              DropdownMenuItem(
                value: ListingSortOrder.newest,
                child: Text(ListingStrings.newest),
              ),
              DropdownMenuItem(
                value: ListingSortOrder.rentLowToHigh,
                child: Text(ListingStrings.rentLowHigh),
              ),
              DropdownMenuItem(
                value: ListingSortOrder.rentHighToLow,
                child: Text(ListingStrings.rentHighLow),
              ),
              DropdownMenuItem(
                value: ListingSortOrder.bedroomsHighToLow,
                child: Text(ListingStrings.bedroomsHighLow),
              ),
            ],
            onChanged: (value) =>
                setState(() => _sort = value ?? ListingSortOrder.newest),
          ),
          const SizedBox(height: 8),
          Text(
            ListingStrings.amenities,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Wrap(
            spacing: 8,
            children: ListingStrings.availableAmenities
                .map(
                  (amenity) => FilterChip(
                    label: Text(amenity),
                    selected: _amenities.contains(amenity),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _amenities.add(amenity);
                      } else {
                        _amenities.remove(amenity);
                      }
                    }),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _apply,
            child: const Text(ListingStrings.apply),
          ),
          TextButton(
            onPressed: () {
              ref.read(listingFilterProvider.notifier).reset();
              context.pop();
            },
            child: const Text(ListingStrings.clear),
          ),
        ],
      ),
    );
  }

  void _apply() {
    final min = int.tryParse(_minController.text);
    final max = int.tryParse(_maxController.text);
    if (min != null && max != null && min > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ListingStrings.rentRangeError)),
      );
      return;
    }
    ref
        .read(listingFilterProvider.notifier)
        .update(
          ListingFilter(
            subCity: _subCity,
            neighbourhood: _neighbourhoodController.text.trim().isEmpty
                ? null
                : _neighbourhoodController.text.trim(),
            minRent: min,
            maxRent: max,
            bedrooms: _bedrooms,
            amenities: _amenities.toList(),
            sortOrder: _sort,
          ),
        );
    context.pop();
  }
}
