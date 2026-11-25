import '../domain/onboarding_repository.dart';
import '../domain/onboarding_state.dart';

class InMemoryOnboardingRepository implements OnboardingRepository {
  InMemoryOnboardingRepository({bool hasSeenOnboarding = false})
    : _state = OnboardingState(hasSeenOnboarding: hasSeenOnboarding);

  OnboardingState _state;

  @override
  OnboardingState getState() => _state;

  @override
  void markSeen() {
    _state = const OnboardingState(hasSeenOnboarding: true);
  }
}
