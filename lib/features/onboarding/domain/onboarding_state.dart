import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';
part 'onboarding_state.g.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({@Default(false) bool hasSeenOnboarding}) =
      _OnboardingState;

  factory OnboardingState.fromJson(Map<String, Object?> json) =>
      _$OnboardingStateFromJson(json);
}
