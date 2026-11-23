import 'onboarding_state.dart';

abstract class OnboardingRepository {
  OnboardingState getState();

  void markSeen();
}
