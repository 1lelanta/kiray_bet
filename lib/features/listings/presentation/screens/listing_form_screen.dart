import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/listing.dart';
import '../listing_strings.dart';
import '../providers/listing_data_providers.dart';
import '../providers/listing_providers.dart';

class ListingFormScreen extends ConsumerStatefulWidget {
  const ListingFormScreen({super.key, this.listingId});
  final String? listingId;

  @override
  ConsumerState<ListingFormScreen> createState() => _ListingFormScreenState();
}

class _ListingFormScreenState extends ConsumerState<ListingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _rent = TextEditingController();
  final _deposit = TextEditingController(text: '2');
  final _bedrooms = TextEditingController(text: '1');
  final _bathrooms = TextEditingController(text: '1');
  final _area = TextEditingController();
  final _neighbourhood = TextEditingController();
  final _address = TextEditingController();
  final _latitude = TextEditingController(text: '8.995');
  final _longitude = TextEditingController(text: '38.789');
  String _subCity = 'Bole';
  ListingStatus _status = ListingStatus.available;
  final List<String> _photos = [];
  final Set<String> _amenities = {};
  Listing? _existing;
  bool _loaded = false;

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _rent,
      _deposit,
      _bedrooms,
      _bathrooms,
      _area,
      _neighbourhood,
      _address,
      _latitude,
      _longitude,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listingId != null) {
      final found = ref.watch(listingByIdProvider(widget.listingId!));
      return found.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, s) =>
            const Scaffold(body: Center(child: Text(ListingStrings.error))),
        data: (listing) {
          if (listing == null) {
            return const Scaffold(
              body: Center(child: Text(ListingStrings.notFound)),
            );
          }
          if (ref.watch(currentOwnerIdProvider) != listing.ownerId) {
            return const Scaffold(
              body: Center(child: Text(ListingStrings.signInRequired)),
            );
          }
          if (!_loaded) _prefill(listing);
          return _form();
        },
      );
    }
    if (ref.watch(currentOwnerIdProvider) == null) {
      return const Scaffold(
        body: Center(child: Text(ListingStrings.signInRequired)),
      );
    }
    return _form();
  }

  Widget _form() => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.listingId == null
            ? ListingStrings.addListing
            : ListingStrings.editListing,
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _text(_title, ListingStrings.title, required: true),
            ListingDescriptionField(
              controller: _description,
              values: ListingDraftValues(
                subCity: _subCity,
                neighbourhood: _neighbourhood.text,
                rentBirr: int.tryParse(_rent.text),
                bedrooms: int.tryParse(_bedrooms.text),
                bathrooms: int.tryParse(_bathrooms.text),
                amenities: _amenities.toList(),
              ),
              onChanged: () => setState(() {}),
            ),
            _text(
              _rent,
              ListingStrings.monthlyRent,
              integer: true,
              required: true,
            ),
            _text(
              _deposit,
              ListingStrings.depositMonths,
              integer: true,
              required: true,
            ),
            _text(
              _bedrooms,
              ListingStrings.bedrooms,
              integer: true,
              required: true,
            ),
            _text(
              _bathrooms,
              ListingStrings.bathrooms,
              integer: true,
              required: true,
            ),
            _text(_area, ListingStrings.area, number: true, required: true),
            DropdownButtonFormField<String>(
              initialValue: _subCity,
              decoration: const InputDecoration(
                labelText: ListingStrings.subCity,
              ),
              items: ListingStrings.subCities
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (v) => setState(() {
                _subCity = v ?? _subCity;
                final point = _subCityCoordinates[_subCity]!;
                _latitude.text = '${point.$1}';
                _longitude.text = '${point.$2}';
              }),
            ),
            _text(_neighbourhood, ListingStrings.neighbourhood, required: true),
            _text(_address, ListingStrings.address, required: true),
            _text(
              _latitude,
              ListingStrings.latitude,
              number: true,
              required: true,
              validator: (value) => _coordinate(value, min: 8.90, max: 9.10),
            ),
            _text(
              _longitude,
              ListingStrings.longitude,
              number: true,
              required: true,
              validator: (value) => _coordinate(value, min: 38.67, max: 38.88),
            ),
            Text(ListingStrings.amenities),
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
            if (widget.listingId != null)
              DropdownButtonFormField<ListingStatus>(
                key: const Key(ListingStrings.status),
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: ListingStrings.status,
                ),
                items: ListingStatus.values
                    .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
            Text('${ListingStrings.photos}: ${_photos.length}'),
            TextButton.icon(
              key: const Key(ListingStrings.addPhoto),
              onPressed: () => setState(
                () => _photos.add('placeholder://photo-${_photos.length + 1}'),
              ),
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text(ListingStrings.addPhoto),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key(ListingStrings.saveListing),
              onPressed: _save,
              child: const Text(ListingStrings.saveListing),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _text(
    TextEditingController c,
    String label, {
    bool number = false,
    bool integer = false,
    bool required = false,
    String? Function(String?)? validator,
  }) => TextFormField(
    key: Key(label),
    controller: c,
    onChanged: (_) => setState(() {}),
    keyboardType: number || integer ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(labelText: label),
    validator:
        validator ??
        (value) {
          if (required && (value == null || value.trim().isEmpty)) {
            return ListingStrings.required;
          }
          if ((number || integer) &&
              value != null &&
              value.trim().isNotEmpty &&
              num.tryParse(value) == null) {
            return ListingStrings.invalidNumber;
          }
          if ((number || integer) &&
              value != null &&
              num.tryParse(value) != null &&
              num.parse(value) < 0) {
            return ListingStrings.invalidNumber;
          }
          if (integer && value != null && int.tryParse(value) == null) {
            return ListingStrings.invalidNumber;
          }
          return null;
        },
  );

  String? _coordinate(
    String? value, {
    required double min,
    required double max,
  }) {
    final coordinate = double.tryParse(value ?? '');
    if (coordinate == null || coordinate < min || coordinate > max) {
      return ListingStrings.coordinateError;
    }
    return null;
  }

  void _prefill(Listing listing) {
    _existing = listing;
    _title.text = listing.title;
    _description.text = listing.description;
    _rent.text = '${listing.monthlyRentBirr}';
    _deposit.text = '${listing.depositMonths}';
    _bedrooms.text = '${listing.bedrooms}';
    _bathrooms.text = '${listing.bathrooms}';
    _area.text = '${listing.areaSqm}';
    _subCity = listing.subCity;
    _neighbourhood.text = listing.neighbourhood;
    _address.text = listing.address;
    _latitude.text = '${listing.latitude}';
    _longitude.text = '${listing.longitude}';
    _amenities.addAll(listing.amenities);
    _status = listing.status;
    _photos.addAll(listing.photoUrls);
    _loaded = true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ListingStrings.photoRequired)),
      );
      return;
    }
    final ownerId = ref.read(currentOwnerIdProvider);
    if (ownerId == null) return;
    final previous = _existing;
    final now = DateTime.now();
    final listing = Listing(
      id: previous?.id ?? 'listing-${now.microsecondsSinceEpoch}',
      ownerId: ownerId,
      title: _title.text.trim(),
      description: _description.text.trim(),
      monthlyRentBirr: int.parse(_rent.text),
      depositMonths: int.parse(_deposit.text),
      bedrooms: int.parse(_bedrooms.text),
      bathrooms: int.parse(_bathrooms.text),
      areaSqm: double.parse(_area.text),
      subCity: _subCity,
      neighbourhood: _neighbourhood.text.trim(),
      address: _address.text.trim(),
      latitude: double.parse(_latitude.text),
      longitude: double.parse(_longitude.text),
      amenities: _amenities.toList(),
      photoUrls: _photos,
      status: _status,
      createdAt: previous?.createdAt ?? now,
      updatedAt: now,
    );
    final repo = ref.read(listingRepositoryProvider);
    if (previous == null) {
      await repo.addListing(listing);
    } else {
      await repo.updateListing(listing);
    }
    ref.invalidate(allListingsProvider);
    ref.invalidate(currentOwnerListingsProvider);
    if (previous != null) {
      ref.invalidate(listingByIdProvider(listing.id));
    }
    if (mounted) context.pop();
  }
}

class ListingDescriptionField extends StatelessWidget {
  const ListingDescriptionField({
    super.key,
    required this.controller,
    required this.values,
    this.builder,
    this.onChanged,
  });
  final TextEditingController controller;
  final ListingDraftValues values;
  final VoidCallback? onChanged;
  final Widget Function(
    BuildContext,
    ListingDraftValues,
    TextEditingController,
  )?
  builder;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextFormField(
        controller: controller,
        onChanged: (_) => onChanged?.call(),
        minLines: 3,
        maxLines: 6,
        decoration: const InputDecoration(
          labelText: ListingStrings.description,
        ),
      ),
      if (builder != null) builder!(context, values, controller),
    ],
  );
}

const _subCityCoordinates = <String, (double, double)>{
  'Bole': (8.995, 38.789),
  'Yeka': (9.024, 38.805),
  'Kirkos': (9.012, 38.766),
  'Lideta': (9.010, 38.731),
  'Arada': (9.035, 38.752),
  'Nifas Silk-Lafto': (8.965, 38.708),
  'Kolfe Keranio': (9.018, 38.690),
  'Gullele': (9.071, 38.758),
};

class ListingDraftValues {
  const ListingDraftValues({
    this.subCity,
    this.neighbourhood,
    this.rentBirr,
    this.bedrooms,
    this.bathrooms,
    this.amenities = const [],
  });
  final String? subCity, neighbourhood;
  final int? rentBirr, bedrooms, bathrooms;
  final List<String> amenities;
}
