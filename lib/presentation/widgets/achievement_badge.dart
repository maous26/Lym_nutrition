import 'package:flutter/material.dart';
import 'package:lym_nutrition/presentation/themes/wellness_colors.dart';

/// Achievement badge widget for gamification system
/// Displays earned achievements with beautiful animations and design
class AchievementBadge extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? color;
  final bool isEarned;
  final bool isNew;
  final VoidCallback? onTap;
  final double? progress; // For progress-based achievements (0.0 to 1.0)

  const AchievementBadge({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.color,
    this.isEarned = false,
    this.isNew = false,
    this.onTap,
    this.progress,
  });

  @override
  State<AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<AchievementBadge>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shineController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shineAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for new achievements
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Scale animation for interactions
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Shine animation for earned achievements
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _shineAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shineController,
      curve: Curves.easeInOut,
    ));

    // Start animations if achievement is new
    if (widget.isNew) {
      _pulseController.repeat(reverse: true);
    }

    // Start shine animation for earned achievements
    if (widget.isEarned) {
      _shineController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  Color get _badgeColor {
    if (widget.color != null) return widget.color!;
    if (widget.isEarned) return WellnessColors.primaryGreen;
    return WellnessColors.textTertiary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        if (widget.isEarned) {
          _pulseController.forward();
        }
      },
      onTapUp: (_) {
        if (widget.isEarned) {
          _pulseController.reverse();
        }
      },
      onTapCancel: () {
        if (widget.isEarned) {
          _pulseController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _shineController]),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isNew ? _pulseAnimation.value : _scaleAnimation.value,
            child: Container(
              width: 120,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(WellnessBorderRadius.lg),
                gradient: widget.isEarned
                    ? LinearGradient(
                        colors: [
                          _badgeColor.withOpacity(0.1),
                          _badgeColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color:
                    widget.isEarned ? null : WellnessColors.backgroundSecondary,
                border: widget.isEarned
                    ? Border.all(
                        color: _badgeColor.withOpacity(0.3),
                        width: 2,
                      )
                    : Border.all(
                        color: WellnessColors.divider,
                        width: 1,
                      ),
                boxShadow: widget.isEarned
                    ? WellnessShadows.medium
                    : WellnessShadows.soft,
              ),
              child: Stack(
                children: [
                  // Shine effect for earned achievements
                  if (widget.isEarned)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(WellnessBorderRadius.lg),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.0,
                                _shineAnimation.value * 0.5 + 0.5,
                                1.0,
                              ],
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(WellnessSpacing.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge icon with glow effect
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isEarned
                                ? _badgeColor
                                : WellnessColors.backgroundTertiary,
                            boxShadow: widget.isEarned
                                ? [
                                    BoxShadow(
                                      color: _badgeColor.withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.isEarned
                                ? Colors.white
                                : WellnessColors.textTertiary,
                            size: 28,
                            semanticLabel: widget.title,
                          ),
                        ),

                        const SizedBox(height: WellnessSpacing.sm),

                        // Title
                        Text(
                          widget.title,
                          style: WellnessTypography.labelLarge.copyWith(
                            color: widget.isEarned
                                ? WellnessColors.textPrimary
                                : WellnessColors.textTertiary,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: WellnessSpacing.xs),

                        // Description
                        Text(
                          widget.description,
                          style: WellnessTypography.labelMedium.copyWith(
                            color: widget.isEarned
                                ? WellnessColors.textSecondary
                                : WellnessColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Progress bar for progress-based achievements
                        if (widget.progress != null && !widget.isEarned) ...[
                          const SizedBox(height: WellnessSpacing.xs),
                          LinearProgressIndicator(
                            value: widget.progress!,
                            backgroundColor: WellnessColors.backgroundTertiary,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(_badgeColor),
                            minHeight: 3,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // New achievement indicator
                  if (widget.isNew)
                    Positioned(
                      top: WellnessSpacing.xs,
                      right: WellnessSpacing.xs,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: WellnessColors.errorCoral,
                          boxShadow: WellnessShadows.soft,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Achievement categories for organization
enum AchievementCategory {
  nutrition,
  hydration,
  consistency,
  goals,
  social,
}

/// Achievement data model
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final AchievementCategory category;
  final int points;
  final bool isEarned;
  final bool isNew;
  final double? progress; // For progress-based achievements
  final DateTime? earnedDate;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    required this.points,
    this.isEarned = false,
    this.isNew = false,
    this.progress,
    this.earnedDate,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    AchievementCategory? category,
    int? points,
    bool? isEarned,
    bool? isNew,
    double? progress,
    DateTime? earnedDate,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      points: points ?? this.points,
      isEarned: isEarned ?? this.isEarned,
      isNew: isNew ?? this.isNew,
      progress: progress ?? this.progress,
      earnedDate: earnedDate ?? this.earnedDate,
    );
  }
}

/// Pre-defined achievements for the nutrition app
class AchievementDefinitions {
  static const List<Achievement> achievements = [
    // Nutrition achievements
    Achievement(
      id: 'first_meal_logged',
      title: 'Premier Repas',
      description: 'Votre premier repas enregistré',
      icon: Icons.restaurant_rounded,
      color: WellnessColors.primaryGreen,
      category: AchievementCategory.nutrition,
      points: 10,
    ),

    Achievement(
      id: 'healthy_week',
      title: 'Semaine Saine',
      description: '7 jours d\'alimentation équilibrée',
      icon: Icons.emoji_events_rounded,
      color: WellnessColors.sunsetOrange,
      category: AchievementCategory.consistency,
      points: 50,
    ),

    Achievement(
      id: 'hydration_hero',
      title: 'Héros de l\'Hydratation',
      description: 'Objectif d\'eau atteint 30 jours',
      icon: Icons.water_drop_rounded,
      color: WellnessColors.secondaryBlue,
      category: AchievementCategory.hydration,
      points: 100,
    ),

    Achievement(
      id: 'veggie_lover',
      title: 'Amoureux des Légumes',
      description: '100 portions de légumes',
      icon: Icons.eco_rounded,
      color: WellnessColors.primaryGreen,
      category: AchievementCategory.nutrition,
      points: 75,
    ),

    Achievement(
      id: 'protein_power',
      title: 'Force Protéinée',
      description: 'Objectif protéines 14 jours',
      icon: Icons.fitness_center_rounded,
      color: WellnessColors.errorCoral,
      category: AchievementCategory.nutrition,
      points: 60,
    ),

    Achievement(
      id: 'consistency_champion',
      title: 'Champion de Régularité',
      description: '30 jours de suivi consécutifs',
      icon: Icons.stars_rounded,
      color: WellnessColors.accentPeach,
      category: AchievementCategory.consistency,
      points: 150,
    ),
  ];
}
