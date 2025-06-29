import 'package:flutter/material.dart';
import 'package:lym_nutrition/presentation/themes/wellness_colors.dart';
import 'dart:math' as math;

/// Animated circular progress chart for nutrition metrics
class NutritionProgressChart extends StatefulWidget {
  final String label;
  final double value;
  final double target;
  final String unit;
  final Color? color;
  final IconData? icon;
  final bool showPercentage;
  final VoidCallback? onTap;

  const NutritionProgressChart({
    super.key,
    required this.label,
    required this.value,
    required this.target,
    required this.unit,
    this.color,
    this.icon,
    this.showPercentage = true,
    this.onTap,
  });

  @override
  State<NutritionProgressChart> createState() => _NutritionProgressChartState();
}

class _NutritionProgressChartState extends State<NutritionProgressChart>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.value / widget.target).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();

    // Pulse if goal is achieved
    if (widget.value >= widget.target) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _chartColor {
    if (widget.color != null) return widget.color!;

    final progress = widget.value / widget.target;
    if (progress >= 1.0) return WellnessColors.primaryGreen;
    if (progress >= 0.8) return WellnessColors.sunsetOrange;
    if (progress >= 0.6) return WellnessColors.accentPeach;
    return WellnessColors.secondaryBlue;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.value / widget.target).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();
    final isGoalMet = widget.value >= widget.target;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_progressController, _pulseController]),
        builder: (context, child) {
          return Transform.scale(
            scale: isGoalMet ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: WellnessColors.backgroundPrimary,
                boxShadow: isGoalMet
                    ? [
                        BoxShadow(
                          color: _chartColor.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : WellnessShadows.soft,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _chartColor.withOpacity(0.1),
                      ),
                    ),
                  ),

                  // Progress circle
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: _progressAnimation.value,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(_chartColor),
                      strokeCap: StrokeCap.round,
                    ),
                  ),

                  // Center content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null)
                        Icon(
                          widget.icon!,
                          color: _chartColor,
                          size: 20,
                        ),
                      if (widget.showPercentage) ...[
                        Text(
                          '${percentage}%',
                          style: WellnessTypography.headlineMedium.copyWith(
                            color: WellnessColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.label,
                          style: WellnessTypography.labelMedium.copyWith(
                            color: WellnessColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        Text(
                          '${widget.value.round()}',
                          style: WellnessTypography.headlineMedium.copyWith(
                            color: WellnessColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.unit,
                          style: WellnessTypography.labelMedium.copyWith(
                            color: WellnessColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Goal achieved indicator
                  if (isGoalMet)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: WellnessColors.primaryGreen,
                          border: Border.all(
                            color: WellnessColors.backgroundPrimary,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 12,
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

/// Weekly progress bar chart
class WeeklyProgressChart extends StatefulWidget {
  final List<double> weeklyData;
  final double maxValue;
  final List<String> dayLabels;
  final String title;
  final Color? color;
  final VoidCallback? onTap;

  const WeeklyProgressChart({
    super.key,
    required this.weeklyData,
    required this.maxValue,
    this.dayLabels = const ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
    required this.title,
    this.color,
    this.onTap,
  });

  @override
  State<WeeklyProgressChart> createState() => _WeeklyProgressChartState();
}

class _WeeklyProgressChartState extends State<WeeklyProgressChart>
    with TickerProviderStateMixin {
  late List<AnimationController> _barControllers;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();

    _barControllers = List.generate(
      widget.weeklyData.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      ),
    );

    _barAnimations = _barControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        _barControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _barControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color get _chartColor {
    return widget.color ?? WellnessColors.primaryGreen;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(WellnessSpacing.lg),
        decoration: BoxDecoration(
          color: WellnessColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(WellnessBorderRadius.lg),
          boxShadow: WellnessShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: WellnessTypography.headlineMedium.copyWith(
                color: WellnessColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: WellnessSpacing.lg),

            // Chart
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.weeklyData.length, (index) {
                  final value = widget.weeklyData[index];
                  final normalizedHeight =
                      (value / widget.maxValue).clamp(0.0, 1.0);
                  final isToday = index == DateTime.now().weekday - 1;

                  return AnimatedBuilder(
                    animation: _barAnimations[index],
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Bar
                          Container(
                            width: 24,
                            height: 80 *
                                normalizedHeight *
                                _barAnimations[index].value,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  _chartColor,
                                  _chartColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                  WellnessBorderRadius.sm),
                              boxShadow:
                                  value > 0 ? WellnessShadows.soft : null,
                            ),
                          ),

                          const SizedBox(height: WellnessSpacing.sm),

                          // Day label
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToday ? _chartColor : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                widget.dayLabels[index],
                                style: WellnessTypography.labelMedium.copyWith(
                                  color: isToday
                                      ? Colors.white
                                      : WellnessColors.textSecondary,
                                  fontWeight: isToday
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hydration progress wave animation
class HydrationWaveProgress extends StatefulWidget {
  final double currentAmount;
  final double targetAmount;
  final String unit;
  final double height;
  final VoidCallback? onTap;

  const HydrationWaveProgress({
    super.key,
    required this.currentAmount,
    required this.targetAmount,
    this.unit = 'ml',
    this.height = 200,
    this.onTap,
  });

  @override
  State<HydrationWaveProgress> createState() => _HydrationWaveProgressState();
}

class _HydrationWaveProgressState extends State<HydrationWaveProgress>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;
  late Animation<double> _waveAnimation;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fillController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(_waveController);

    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.currentAmount / widget.targetAmount).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeInOut,
    ));

    _waveController.repeat();
    _fillController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        (widget.currentAmount / widget.targetAmount).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: WellnessColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(WellnessBorderRadius.lg),
          boxShadow: WellnessShadows.soft,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(WellnessBorderRadius.lg),
          child: Stack(
            children: [
              // Water fill with wave animation
              AnimatedBuilder(
                animation: Listenable.merge([_waveController, _fillController]),
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(double.infinity, widget.height),
                    painter: WavePainter(
                      waveValue: _waveAnimation.value,
                      fillLevel: _fillAnimation.value,
                      color: WellnessColors.secondaryBlue,
                    ),
                  );
                },
              ),

              // Content overlay
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop_rounded,
                      color: progress > 0.5
                          ? Colors.white.withOpacity(0.9)
                          : WellnessColors.secondaryBlue,
                      size: 32,
                    ),
                    const SizedBox(height: WellnessSpacing.sm),
                    Text(
                      '${widget.currentAmount.round()} ${widget.unit}',
                      style: WellnessTypography.displayMedium.copyWith(
                        color: progress > 0.5
                            ? Colors.white
                            : WellnessColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'sur ${widget.targetAmount.round()} ${widget.unit} (${percentage}%)',
                      style: WellnessTypography.bodyMedium.copyWith(
                        color: progress > 0.5
                            ? Colors.white.withOpacity(0.9)
                            : WellnessColors.textSecondary,
                      ),
                    ),
                    if (progress >= 1.0) ...[
                      const SizedBox(height: WellnessSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: WellnessSpacing.md,
                          vertical: WellnessSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(WellnessBorderRadius.md),
                        ),
                        child: Text(
                          '🎉 Objectif atteint !',
                          style: WellnessTypography.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for wave animation
class WavePainter extends CustomPainter {
  final double waveValue;
  final double fillLevel;
  final Color color;

  WavePainter({
    required this.waveValue,
    required this.fillLevel,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 8.0;
    final fillHeight = size.height * (1 - fillLevel);

    // Start from bottom left
    path.moveTo(0, size.height);
    path.lineTo(0, fillHeight);

    // Create wave
    for (double x = 0; x <= size.width; x += 1) {
      final y = fillHeight +
          waveHeight * math.sin((x / size.width * 2 * math.pi) + waveValue);
      path.lineTo(x, y);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Add shimmer effect
    final shimmerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, shimmerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
