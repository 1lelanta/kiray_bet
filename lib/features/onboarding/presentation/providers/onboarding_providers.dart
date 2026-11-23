import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/in_memory_onboarding_repository.dart';
import '../../domain/onboarding_repository.dart';
import '../../domain/onboarding_state.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return InMemoryOnboardingRepository();
});

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return ref.read(onboardingRepositoryProvider).getState();
  }

  void markSeen() {
    ref.read(onboardingRepositoryProvider).markSeen();
    state = ref.read(onboardingRepositoryProvider).getState();
  }
}
