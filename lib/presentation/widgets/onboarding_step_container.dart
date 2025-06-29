// lib/presentation/widgets/onboarding_step_container.dart
import 'package:flutter/material.dart';
import 'package:lym_nutrition/presentation/themes/premium_theme.dart';

class OnboardingStepContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final VoidCallback onNext;
  final String nextButtonText;
  final bool isLoading;

  const OnboardingStepContainer({
    Key? key,
    required this.title,
    this.subtitle,
    required this.content,
    required this.onNext,
    this.nextButtonText = 'Suivant',
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec titre et sous-titre
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Contenu principal
            content,

            const SizedBox(height: 24),

            // Bouton suivant
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PremiumTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(PremiumTheme.borderRadiusMedium),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        nextButtonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
