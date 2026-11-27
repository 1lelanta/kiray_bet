import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/constants/route_paths.dart';
import '../onboarding_strings.dart';
import '../providers/onboarding_providers.dart';

/// Three-page introduction shown before the main app.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static List<({IconData icon, String title, String text})> get _pages => [
    (
      icon: Icons.home_work_outlined,
      title: OnboardingStrings.findHomeTitle,
      text: OnboardingStrings.findHomeText,
    ),
    (
      icon: Icons.compare_arrows,
      title: OnboardingStrings.compareTitle,
      text: OnboardingStrings.compareText,
    ),
    (
      icon: Icons.verified_user_outlined,
      title: OnboardingStrings.reportTitle,
      text: OnboardingStrings.reportText,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    ref.read(onboardingNotifierProvider.notifier).markSeen();
    context.go(RoutePaths.splash);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: OnboardingStrings.title,
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        page.icon,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        page.text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _currentPage == index ? 18 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                if (_currentPage < 2)
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(OnboardingStrings.skip),
                  ),
                const Spacer(),
                if (_currentPage < 2)
                  FilledButton(
                    onPressed: _nextPage,
                    child: Text(OnboardingStrings.next),
                  )
                else
                  FilledButton(
                    onPressed: _finishOnboarding,
                    child: Text(OnboardingStrings.getStarted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
