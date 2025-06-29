import 'package:flutter/material.dart';
import '../themes/wellness_colors.dart';
import '../themes/wellness_theme.dart';

/// Modern dashboard header with personalized greeting and AI assistant
/// Features: Warm greeting, progress visualization, quick stats, AI avatar
class WellnessDashboardHeader extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final double dailyProgress; // 0.0 - 1.0
  final int caloriesConsumed;
  final int caloriesGoal;
  final int streakDays;
  final VoidCallback onAiAssistantTap;

  const WellnessDashboardHeader({
    Key? key,
    required this.userName,
    this.userAvatar = '',
    required this.dailyProgress,
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.streakDays,
    required this.onAiAssistantTap,
  }) : super(key: key);

  @override
  State<WellnessDashboardHeader> createState() =>
      _WellnessDashboardHeaderState();
}

class _WellnessDashboardHeaderState extends State<WellnessDashboardHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _greetingMessage {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bonjour';
    if (hour < 17) return 'Bon après-midi';
    return 'Bonsoir';
  }

  String get _motivationalMessage {
    if (widget.dailyProgress >= 0.9)
      return 'Excellent travail aujourd\'hui! 🎉';
    if (widget.dailyProgress >= 0.7) return 'Vous êtes sur la bonne voie! 💪';
    if (widget.dailyProgress >= 0.5) return 'Continuez comme ça! 🌟';
    return 'C\'est un nouveau jour plein de possibilités! ✨';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            WellnessColors.neutralCream,
            WellnessColors.backgroundSecondary,
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(WellnessBorderRadius.xxl),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(WellnessSpacing.lg),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with greeting and AI assistant
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$_greetingMessage,',
                                  style: WellnessTypography.headlineMedium
                                      .copyWith(
                                    color: WellnessColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  widget.userName,
                                  style:
                                      WellnessTypography.displayMedium.copyWith(
                                    color: WellnessColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: WellnessSpacing.xs),
                                Text(
                                  _motivationalMessage,
                                  style: WellnessTypography.bodyMedium.copyWith(
                                    color: WellnessColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // AI Assistant Avatar
                          GestureDetector(
                            onTap: widget.onAiAssistantTap,
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: WellnessColors.aiAvatarGradient,
                                ),
                                borderRadius: BorderRadius.circular(
                                    WellnessBorderRadius.circular),
                                boxShadow: WellnessShadows.medium,
                              ),
                              child: const Icon(
                                Icons.psychology_rounded, // AI brain icon
                                color: Colors.white,
                                size: 28,
                                semanticLabel: 'Assistant IA Nutrition',
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: WellnessSpacing.xl),

                      // Progress section
                      Row(
                        children: [
                          // Daily progress circle
                          Expanded(
                            flex: 2,
                            child: _buildProgressCircle(),
                          ),

                          const SizedBox(width: WellnessSpacing.lg),

                          // Stats cards
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                _buildStatCard(
                                  'Calories',
                                  '${widget.caloriesConsumed}/${widget.caloriesGoal}',
                                  Icons.local_fire_department_rounded,
                                  WellnessColors.errorCoral,
                                ),
                                const SizedBox(height: WellnessSpacing.sm),
                                _buildStatCard(
                                  'Série',
                                  '${widget.streakDays} jours',
                                  Icons.emoji_events_rounded,
                                  WellnessColors.sunsetOrange,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCircle() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: WellnessShadows.soft,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: WellnessColors.backgroundPrimary,
            ),
          ),
          // Progress indicator
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: widget.dailyProgress,
              strokeWidth: 8,
              backgroundColor: WellnessColors.backgroundTertiary,
              valueColor: AlwaysStoppedAnimation(
                WellnessColors.getNutritionScoreColor(widget.dailyProgress * 5),
              ),
            ),
          ),
          // Progress text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(widget.dailyProgress * 100).round()}%',
                style: WellnessTypography.headlineMedium.copyWith(
                  color: WellnessColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Objectif',
                style: WellnessTypography.labelMedium.copyWith(
                  color: WellnessColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(WellnessSpacing.md),
      decoration: BoxDecoration(
        color: WellnessColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(WellnessBorderRadius.md),
        boxShadow: WellnessShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(WellnessBorderRadius.sm),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
              semanticLabel: title,
            ),
          ),
          const SizedBox(width: WellnessSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: WellnessTypography.labelLarge.copyWith(
                    color: WellnessColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  title,
                  style: WellnessTypography.labelMedium.copyWith(
                    color: WellnessColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
