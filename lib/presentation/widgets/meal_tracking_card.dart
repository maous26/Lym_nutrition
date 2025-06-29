import 'package:flutter/material.dart';
import '../themes/wellness_colors.dart';
import '../themes/wellness_theme.dart';

/// Modern meal tracking card with engaging visuals and AI recommendations
/// Features: Beautiful meal imagery, nutritional highlights, AI suggestions
class MealTrackingCard extends StatefulWidget {
  final String mealName;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final String imageUrl;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double nutritionScore; // 0.0 - 5.0
  final List<String> aiSuggestions;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MealTrackingCard({
    Key? key,
    required this.mealName,
    required this.mealType,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.nutritionScore,
    this.aiSuggestions = const [],
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<MealTrackingCard> createState() => _MealTrackingCardState();
}

class _MealTrackingCardState extends State<MealTrackingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _mealTypeColor {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return WellnessColors.sunsetOrange;
      case 'lunch':
        return WellnessColors.primaryGreen;
      case 'dinner':
        return WellnessColors.secondaryBlue;
      case 'snack':
        return WellnessColors.accentPeach;
      default:
        return WellnessColors.textSecondary;
    }
  }

  IconData get _mealTypeIcon {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'dinner':
        return Icons.dinner_dining_rounded;
      case 'snack':
        return Icons.cookie_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  String get _mealTypeLabel {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return 'Petit-déjeuner';
      case 'lunch':
        return 'Déjeuner';
      case 'dinner':
        return 'Dîner';
      case 'snack':
        return 'Collation';
      default:
        return 'Repas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.mealName}, $_mealTypeLabel, ${widget.calories} calories',
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: WellnessSpacing.md,
                  vertical: WellnessSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: WellnessColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(WellnessBorderRadius.lg),
                  boxShadow: _isPressed
                      ? WellnessShadows.soft
                      : WellnessShadows.medium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Meal image and header
                    _buildMealHeader(),

                    // Meal details
                    Padding(
                      padding: const EdgeInsets.all(WellnessSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Meal name and nutrition score
                          _buildMealTitle(),

                          const SizedBox(height: WellnessSpacing.sm),

                          // Nutritional breakdown
                          _buildNutritionalBreakdown(),

                          // AI suggestions (if any)
                          if (widget.aiSuggestions.isNotEmpty) ...[
                            const SizedBox(height: WellnessSpacing.md),
                            _buildAiSuggestions(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMealHeader() {
    return Stack(
      children: [
        // Meal image
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(WellnessBorderRadius.lg),
            ),
            image: widget.imageUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
            gradient: widget.imageUrl.isEmpty
                ? LinearGradient(
                    colors: [
                      _mealTypeColor.withOpacity(0.3),
                      _mealTypeColor.withOpacity(0.1),
                    ],
                  )
                : null,
          ),
          child: widget.imageUrl.isEmpty
              ? Center(
                  child: Icon(
                    _mealTypeIcon,
                    size: 48,
                    color: _mealTypeColor,
                    semanticLabel: _mealTypeLabel,
                  ),
                )
              : null,
        ),

        // Meal type badge
        Positioned(
          top: WellnessSpacing.sm,
          left: WellnessSpacing.sm,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: WellnessSpacing.sm,
              vertical: WellnessSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: _mealTypeColor.withOpacity(0.9),
              borderRadius:
                  BorderRadius.circular(WellnessBorderRadius.circular),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _mealTypeIcon,
                  size: 16,
                  color: Colors.white,
                  semanticLabel: _mealTypeLabel,
                ),
                const SizedBox(width: WellnessSpacing.xs),
                Text(
                  _mealTypeLabel,
                  style: WellnessTypography.labelMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Action buttons
        if (widget.onEdit != null || widget.onDelete != null)
          Positioned(
            top: WellnessSpacing.sm,
            right: WellnessSpacing.sm,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.onEdit != null)
                  _buildActionButton(
                    Icons.edit_rounded,
                    'Modifier',
                    widget.onEdit!,
                  ),
                if (widget.onDelete != null) ...[
                  const SizedBox(width: WellnessSpacing.xs),
                  _buildActionButton(
                    Icons.delete_rounded,
                    'Supprimer',
                    widget.onDelete!,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(WellnessBorderRadius.circular),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.white,
          semanticLabel: label,
        ),
      ),
    );
  }

  Widget _buildMealTitle() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mealName,
                style: WellnessTypography.headlineMedium.copyWith(
                  color: WellnessColors.textPrimary,
                ),
              ),
              const SizedBox(height: WellnessSpacing.xs),
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: WellnessColors.errorCoral,
                    semanticLabel: 'Calories',
                  ),
                  const SizedBox(width: WellnessSpacing.xs),
                  Text(
                    '${widget.calories} kcal',
                    style: WellnessTypography.bodyMedium.copyWith(
                      color: WellnessColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Nutrition score badge
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: WellnessColors.getNutritionScoreColor(widget.nutritionScore),
            boxShadow: WellnessShadows.soft,
          ),
          child: Center(
            child: Text(
              widget.nutritionScore.toStringAsFixed(1),
              style: WellnessTypography.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalBreakdown() {
    return Row(
      children: [
        _buildNutritionalPill(
            'Protéines', '${widget.protein}g', WellnessColors.primaryGreen),
        const SizedBox(width: WellnessSpacing.sm),
        _buildNutritionalPill(
            'Glucides', '${widget.carbs}g', WellnessColors.secondaryBlue),
        const SizedBox(width: WellnessSpacing.sm),
        _buildNutritionalPill(
            'Lipides', '${widget.fat}g', WellnessColors.accentPeach),
      ],
    );
  }

  Widget _buildNutritionalPill(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: WellnessSpacing.sm,
          vertical: WellnessSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(WellnessBorderRadius.circular),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: WellnessTypography.labelLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: WellnessTypography.labelMedium.copyWith(
                color: WellnessColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSuggestions() {
    return Container(
      padding: const EdgeInsets.all(WellnessSpacing.sm),
      decoration: BoxDecoration(
        color: WellnessColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(WellnessBorderRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_rounded,
                size: 18,
                color: WellnessColors.secondaryBlue,
                semanticLabel: 'Suggestions IA',
              ),
              const SizedBox(width: WellnessSpacing.xs),
              Text(
                'Suggestions IA',
                style: WellnessTypography.labelMedium.copyWith(
                  color: WellnessColors.secondaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: WellnessSpacing.xs),
          ...widget.aiSuggestions.take(2).map((suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: WellnessSpacing.xs),
                child: Text(
                  '• $suggestion',
                  style: WellnessTypography.bodyMedium.copyWith(
                    color: WellnessColors.textSecondary,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
