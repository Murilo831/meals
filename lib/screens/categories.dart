import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';
import 'package:meals/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.avaliableMeals});

  final List<Meal> avaliableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

/***
 * 
 * SingleTickerProviderStateMixin:
 * 
 * Fornece varios recursos que são necessários 
 * pelo sistema de animação Flutter
 */

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      //Deixa a animação mais suave
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward(); // inicia a animação
  }

  // Remove animationController da memória para garantir que não cause nenhum transbordo de memória
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.avaliableMeals
        .where(
          (meal) => meal.categories.contains(category.id),
        )
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          meals: filteredMeals, // o que tem na categoria
          title: category.title, //Titulo da categoria
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        //controla o layout
        gridDelegate:
            //Define o número de colunas
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Numero de colunas
          childAspectRatio: 3 / 2, //Diminui a altura
          crossAxisSpacing: 20, //Espaçamento entre colunas
          mainAxisSpacing: 20, // 20px horizontal e vertical
        ),
        children: [
          // availableCategories.map((category) => categoryGridItem(category: category)).toList()

          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              //type Function no CategoryGridItem
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
    );
  }
}
