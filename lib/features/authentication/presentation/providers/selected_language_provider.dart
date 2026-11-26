import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'authentication_providers.dart';

final selectedLanguageProvider =
    NotifierProvider<SelectedLanguageNotifier, String>(
      SelectedLanguageNotifier.new,
    );

class SelectedLanguageNotifier extends Notifier<String> {
  @override
  String build() => ref.watch(currentUserProvider)?.preferredLanguage ?? 'en';

  void setLanguage(String languageCode) {
    if (languageCode != 'en' && languageCode != 'am') {
      throw ArgumentError.value(languageCode, 'languageCode');
    }
    final current = ref.read(currentUserProvider);
    if (current != null) {
      ref
          .read(currentUserProvider.notifier)
          .updateProfile(
            name: current.name,
            phone: current.phone,
            preferredLanguage: languageCode,
          );
    }
    state = languageCode;
  }
}
