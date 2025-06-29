// lib/presentation/screens/food_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lym_nutrition/domain/entities/food_item.dart';
import 'package:lym_nutrition/presentation/bloc/food_detail/food_detail_bloc.dart';
import 'package:lym_nutrition/presentation/bloc/food_detail/food_detail_event.dart';
import 'package:lym_nutrition/presentation/bloc/food_detail/food_detail_state.dart';
import 'package:lym_nutrition/presentation/themes/premium_theme.dart';
import 'package:lym_nutrition/presentation/widgets/nutrition_score_badge.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealSelectionDialog extends StatefulWidget {
  final FoodItem food;

  const MealSelectionDialog({super.key, required this.food});

  @override
  State<MealSelectionDialog> createState() => _MealSelectionDialogState();
}

class _MealSelectionDialogState extends State<MealSelectionDialog> {
  String selectedMeal = 'Petit-déjeuner';
  double quantity = 100;
  String unit = 'g';
  final _quantityController = TextEditingController(text: '100');

  final List<String> meals = [
    'Petit-déjeuner',
    'Déjeuner',
    'Dîner',
    'Collation',
  ];

  final List<String> units = ['g', 'ml', 'portion'];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter ${widget.food.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélection du repas
            Text(
              'Repas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMeal,
                  isExpanded: true,
                  items: meals.map((meal) {
                    return DropdownMenuItem(
                      value: meal,
                      child: Text(meal),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMeal = value;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quantité
            Text(
              'Quantité',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        setState(() {
                          quantity = parsed;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: unit,
                        isExpanded: true,
                        items: units.map((u) {
                          return DropdownMenuItem(
                            value: u,
                            child: Text(u),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              unit = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Informations nutritionnelles pour la quantité sélectionnée
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valeurs nutritionnelles pour ${quantity.toStringAsFixed(0)} $unit',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutrientInfo(
                        'Calories',
                        '${(widget.food.calories * quantity / 100).round()} kcal',
                      ),
                      _buildNutrientInfo(
                        'Protéines',
                        '${(widget.food.proteins * quantity / 100).toStringAsFixed(1)} g',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutrientInfo(
                        'Glucides',
                        '${(widget.food.carbs * quantity / 100).toStringAsFixed(1)} g',
                      ),
                      _buildNutrientInfo(
                        'Lipides',
                        '${(widget.food.fats * quantity / 100).toStringAsFixed(1)} g',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'meal': selectedMeal,
              'quantity': quantity,
              'unit': unit,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: PremiumTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Ajouter'),
        ),
      ],
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class FoodDetailScreen extends StatefulWidget {
  final String foodId;
  final String foodSource;

  const FoodDetailScreen({
    super.key,
    required this.foodId,
    required this.foodSource,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // Réduit de 3 à 2 onglets
    _scrollController.addListener(_onScroll);

    // Charger les détails de l'aliment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodDetailBloc>().add(
            GetFoodDetailEvent(id: widget.foodId, source: widget.foodSource),
          );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 150 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset <= 150 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FoodDetailBloc, FoodDetailState>(
        builder: (context, state) {
          if (state is FoodDetailLoading) {
            return _buildLoadingScreen();
          } else if (state is FoodDetailError) {
            return _buildErrorScreen(state.message);
          } else if (state is FoodDetailLoaded) {
            return _buildDetailScreen(state.food);
          }

          // État initial
          return _buildLoadingScreen();
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'aliment'),
        backgroundColor: PremiumTheme.primaryColor,
      ),
      body: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(PremiumTheme.primaryColor),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erreur'),
        backgroundColor: PremiumTheme.error,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 80, color: PremiumTheme.error),
              const SizedBox(height: 24),
              Text(
                'Une erreur est survenue',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<FoodDetailBloc>().add(
                        GetFoodDetailEvent(
                          id: widget.foodId,
                          source: widget.foodSource,
                        ),
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PremiumTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailScreen(FoodItem food) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final sourceColor = food.source == 'ciqual'
        ? PremiumTheme.primaryColor
        : PremiumTheme.secondaryColor;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: sourceColor,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedOpacity(
                  opacity: _showTitle ? 1.0 : 0.0,
                  duration: PremiumTheme.animationFast,
                  child: Text(
                    food.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                background: _buildFoodHeader(food, sourceColor),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: sourceColor,
                    labelColor: sourceColor,
                    unselectedLabelColor:
                        theme.colorScheme.onSurface.withOpacity(0.7),
                    tabs: const [
                      Tab(text: 'Résumé'),
                      Tab(text: 'Nutriments'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Onglet Résumé
            _buildSummaryTab(food, theme, textTheme),

            // Onglet Nutriments
            _buildNutrientsTab(food, theme, textTheme),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Afficher le dialogue de sélection de repas
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) => MealSelectionDialog(food: food),
          );

          // Traiter le résultat si l'utilisateur a validé
          if (result != null) {
            String meal = result['meal'];
            double quantity = result['quantity'];
            String unit = result['unit'];

            // Afficher un message de confirmation
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${food.name} ajouté à $meal (${quantity.toStringAsFixed(0)} $unit)',
                  ),
                  backgroundColor: PremiumTheme.success,
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'D\'accord',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
          }
        },
        backgroundColor: sourceColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFoodHeader(FoodItem food, Color sourceColor) {
    if (food.imageUrl.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          // Image d'arrière-plan
          CachedNetworkImage(
            imageUrl: food.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: sourceColor,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [sourceColor.withOpacity(0.8), sourceColor],
                ),
              ),
              child: Center(
                child: Icon(
                  food.isProcessed ? Icons.fastfood : Icons.eco,
                  color: Colors.white.withOpacity(0.7),
                  size: 60,
                ),
              ),
            ),
          ),

          // Dégradé pour assurer la lisibilité du texte
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                stops: const [0.5, 1.0],
              ),
            ),
          ),

          // Informations principales
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (food.brand != null && food.brand!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      food.brand!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Pas d'image, utiliser un dégradé avec une icône
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [sourceColor.withOpacity(0.8), sourceColor],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Icône centrale
            Center(
              child: Icon(
                food.isProcessed ? Icons.fastfood : Icons.eco,
                color: Colors.white.withOpacity(0.5),
                size: 80,
              ),
            ),

            // Informations principales
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (food.brand != null && food.brand!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        food.brand!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
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

  Widget _buildSummaryTab(FoodItem food, ThemeData theme, TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations de base
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(PremiumTheme.borderRadiusLarge),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: PremiumTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Informations de base',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    'Catégorie',
                    food.category,
                    Icons.category,
                    theme,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Type',
                    food.isProcessed ? 'Transformé' : 'Frais',
                    food.isProcessed ? Icons.fastfood : Icons.eco,
                    theme,
                  ),
                  if (food.brand != null && food.brand!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow('Marque', food.brand!, Icons.business, theme),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Score nutritionnel
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(PremiumTheme.borderRadiusLarge),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.stars,
                          color: PremiumTheme.primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Score nutritionnel',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      NutritionScoreBadge(
                        score: food.nutritionScore,
                        size: 60,
                        showLabel: false,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              PremiumTheme.getNutritionScoreLabel(
                                food.nutritionScore,
                              ),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: PremiumTheme.getNutritionScoreColor(
                                  food.nutritionScore,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Score basé sur les recommandations nutritionnelles de l\'OMS',
                              style: textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Macronutriments
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(PremiumTheme.borderRadiusLarge),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pie_chart,
                        color: PremiumTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Macronutriments',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutrientCircle(
                        'Calories',
                        '${food.calories.round()}',
                        'kcal',
                        PremiumTheme.accentColor,
                        theme,
                      ),
                      _buildNutrientCircle(
                        'Protéines',
                        food.proteins.toStringAsFixed(1),
                        'g',
                        Colors.blue,
                        theme,
                      ),
                      _buildNutrientCircle(
                        'Glucides',
                        food.carbs.toStringAsFixed(1),
                        'g',
                        Colors.orange,
                        theme,
                      ),
                      _buildNutrientCircle(
                        'Lipides',
                        food.fats.toStringAsFixed(1),
                        'g',
                        Colors.red,
                        theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // MODIFICATION ICI: Nouvelles barres pour "Lipides, dont graisses saturées" et "Glucides, dont sucres"
                  Column(
                    children: [
                      // Lipides et graisses saturées
                      _buildDualNutrientBar(
                        'Lipides',
                        food.fats,
                        'dont graisses saturées',
                        _getSaturatedFats(food),
                        'g',
                        Colors.red,
                        Colors.red.shade900,
                        theme,
                      ),

                      const SizedBox(height: 16),

                      // Glucides et sucres
                      _buildDualNutrientBar(
                        'Glucides',
                        food.carbs,
                        'dont sucres',
                        food.sugar,
                        'g',
                        Colors.orange,
                        Colors.pink,
                        theme,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Valeurs pour 100g de produit',
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Nouvelle méthode pour obtenir les graisses saturées
  double _getSaturatedFats(FoodItem food) {
    // Essayer de récupérer les graisses saturées depuis les nutriments
    if (food.nutrients.containsKey('AG saturés (g/100 g)')) {
      var value = food.nutrients['AG saturés (g/100 g)'];
      if (value is String) {
        if (value.startsWith('<')) {
          return (double.tryParse(value.substring(1).trim()) ?? 0.0) / 2;
        }
        return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
      }
      if (value is num) {
        return value.toDouble();
      }
    }

    // Si pas disponible, estimer à 30% des lipides totaux
    return food.fats * 0.3;
  }

// Nouvelle méthode pour afficher les barres doubles
  Widget _buildDualNutrientBar(
    String mainLabel,
    double mainValue,
    String subLabel,
    double subValue,
    String unit,
    Color mainColor,
    Color subColor,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Étiquette principale
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mainLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${mainValue.toStringAsFixed(1)} $unit',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Barre principale
        Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PremiumTheme.borderRadiusSmall),
            color: mainColor.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              // Valeur principale
              FractionallySizedBox(
                widthFactor: _getWidthFactor(mainValue),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(PremiumTheme.borderRadiusSmall),
                    color: mainColor.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Étiquette secondaire
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              '${subValue.toStringAsFixed(1)} $unit',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: subColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 2),

        // Barre secondaire
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PremiumTheme.borderRadiusSmall),
            color: subColor.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              // Valeur secondaire
              FractionallySizedBox(
                widthFactor: _getWidthFactor(subValue),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(PremiumTheme.borderRadiusSmall),
                    color: subColor.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Calculer le facteur de largeur pour les barres
  double _getWidthFactor(double value) {
    // Limiter la largeur à un maximum raisonnable
    // Considérons qu'une valeur de 50g est 100%
    return (value / 50.0).clamp(0.0, 1.0);
  }

  Widget _buildNutrientsTab(
    FoodItem food,
    ThemeData theme,
    TextTheme textTheme,
  ) {
    // Liste des nutriments à afficher
    final nutrientCategories = [
      {
        'title': 'Macronutriments',
        'icon': Icons.pie_chart,
        'nutrients': [
          {
            'name': 'Calories',
            'value': '${food.calories.round()}',
            'unit': 'kcal',
          },
          {
            'name': 'Protéines',
            'value': food.proteins.toStringAsFixed(1),
            'unit': 'g',
          },
          {
            'name': 'Glucides',
            'value': food.carbs.toStringAsFixed(1),
            'unit': 'g',
          },
          {
            'name': 'dont Sucres',
            'value': food.sugar.toStringAsFixed(1),
            'unit': 'g',
          },
          {
            'name': 'Lipides',
            'value': food.fats.toStringAsFixed(1),
            'unit': 'g',
          },
          {
            'name': 'Fibres',
            'value': food.fiber.toStringAsFixed(1),
            'unit': 'g',
          },
        ],
      },
    ];

    // Ajouter d'autres catégories si les nutriments sont disponibles
    if (food.nutrients.containsKey('AG saturés (g/100 g)')) {
      nutrientCategories.add({
        'title': 'Acides gras',
        'icon': Icons.oil_barrel,
        'nutrients': [
          {
            'name': 'Acides gras saturés',
            'value': _getNutrientValue(food.nutrients, 'AG saturés (g/100 g)'),
            'unit': 'g',
          },
          {
            'name': 'Acides gras monoinsaturés',
            'value': _getNutrientValue(
              food.nutrients,
              'AG monoinsaturés (g/100 g)',
            ),
            'unit': 'g',
          },
          {
            'name': 'Acides gras polyinsaturés',
            'value': _getNutrientValue(
              food.nutrients,
              'AG polyinsaturés (g/100 g)',
            ),
            'unit': 'g',
          },
        ],
      });
    }

    if (food.nutrients.containsKey('Sel chlorure de sodium (g/100 g)') ||
        food.nutrients.containsKey('Sodium (mg/100 g)')) {
      nutrientCategories.add({
        'title': 'Minéraux',
        'icon': Icons.spa,
        'nutrients': [
          {
            'name': 'Sel',
            'value': _getNutrientValue(
              food.nutrients,
              'Sel chlorure de sodium (g/100 g)',
            ),
            'unit': 'g',
          },
          {
            'name': 'Sodium',
            'value': _getNutrientValue(food.nutrients, 'Sodium (mg/100 g)'),
            'unit': 'mg',
          },
          {
            'name': 'Calcium',
            'value': _getNutrientValue(food.nutrients, 'Calcium (mg/100 g)'),
            'unit': 'mg',
          },
          {
            'name': 'Fer',
            'value': _getNutrientValue(food.nutrients, 'Fer (mg/100 g)'),
            'unit': 'mg',
          },
          {
            'name': 'Magnésium',
            'value': _getNutrientValue(food.nutrients, 'Magnésium (mg/100 g)'),
            'unit': 'mg',
          },
          {
            'name': 'Potassium',
            'value': _getNutrientValue(food.nutrients, 'Potassium (mg/100 g)'),
            'unit': 'mg',
          },
          {
            'name': 'Zinc',
            'value': _getNutrientValue(food.nutrients, 'Zinc (mg/100 g)'),
            'unit': 'mg',
          },
        ],
      });
    }

    if (food.nutrients.containsKey('Vitamine C (mg/100 g)') ||
        food.nutrients.containsKey('Vitamine B1 ou Thiamine (mg/100 g)')) {
      nutrientCategories.add({
        'title': 'Vitamines',
        'icon': Icons.opacity,
        'nutrients': [
          {
            'name': 'Vitamine A (Rétinol)',
            'value': _getNutrientValue(food.nutrients, 'Rétinol (µg/100 g)'),
            'unit': 'µg',
          },
          {
            'name': 'Vitamine C',
            'value': _getNutrientValue(food.nutrients, 'Vitamine C (mg/100 g)'),
            'unit': 'mg',
          },
          {
            'name': 'Vitamine B1 (Thiamine)',
            'value': _getNutrientValue(
              food.nutrients,
              'Vitamine B1 ou Thiamine (mg/100 g)',
            ),
            'unit': 'mg',
          },
          {
            'name': 'Vitamine B2 (Riboflavine)',
            'value': _getNutrientValue(
              food.nutrients,
              'Vitamine B2 ou Riboflavine (mg/100 g)',
            ),
            'unit': 'mg',
          },
          {
            'name': 'Vitamine B3 (Niacine)',
            'value': _getNutrientValue(
              food.nutrients,
              'Vitamine B3 ou PP ou Niacine (mg/100 g)',
            ),
            'unit': 'mg',
          },
          {
            'name': 'Vitamine B9 (Folates)',
            'value': _getNutrientValue(
              food.nutrients,
              'Vitamine B9 ou Folates totaux (µg/100 g)',
            ),
            'unit': 'µg',
          },
        ],
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Valeurs nutritionnelles pour 100g',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Source: ${food.source == 'ciqual' ? 'CIQUAL' : 'OpenFoodFacts'}',
            style: textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Afficher chaque catégorie de nutriments
          ...nutrientCategories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    PremiumTheme.borderRadiusLarge,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            category['icon'] as IconData,
                            color: PremiumTheme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category['title'] as String,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      ...((category['nutrients'] as List<Map<String, String>>)
                          .where(
                        (nutrient) =>
                            nutrient['value'] != null &&
                            nutrient['value'] != '0' &&
                            nutrient['value'] != '-',
                      )
                          .map((nutrient) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                nutrient['name']!,
                                style: textTheme.bodyMedium,
                              ),
                              Text(
                                '${nutrient['value']} ${nutrient['unit']}',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientCircle(
    String label,
    String value,
    String unit,
    Color color,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  unit,
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  String _getNutrientValue(Map<String, dynamic> nutrients, String key) {
    if (!nutrients.containsKey(key) ||
        nutrients[key] == null ||
        nutrients[key] == '-') {
      return '0';
    }

    var value = nutrients[key];
    if (value is String) {
      if (value.startsWith('<')) {
        return value;
      }
      return double.tryParse(value.replaceAll(',', '.'))?.toStringAsFixed(1) ??
          '0';
    }

    if (value is num) {
      return value.toStringAsFixed(1);
    }

    return '0';
  }
}
