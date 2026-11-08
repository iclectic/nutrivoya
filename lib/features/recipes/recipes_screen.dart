import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/models/food.dart';
import '../../core/models/food_search_result.dart';
import '../../core/models/nutrient.dart';
import '../../core/utils/uuid.dart';
import '../food/food_providers.dart';
import 'recipe.dart';
import 'recipe_providers.dart';

String _fmt(double? v) => v == null ? '—' : v.round().toString();

String _nutritionLine(AppLocalizations l10n, Recipe r) => l10n.recipeNutritionLine(
      _fmt(r.perServing(NutrientCode.energyKcal)),
      _fmt(r.perServing(NutrientCode.proteinG)),
      _fmt(r.perServing(NutrientCode.carbohydrateG)),
      _fmt(r.perServing(NutrientCode.fatG)),
    );

/// Lists personal recipes; tapping one opens it as a loggable food.
class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recipes = ref.watch(recipesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recipesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('recipes-new'),
        onPressed: () => context.push('/recipes/edit'),
        icon: const Icon(Icons.add),
        label: Text(l10n.recipeNew),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.recipesEmpty, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              children: [
                for (final r in recipes)
                  ListTile(
                    key: Key('recipe-${r.id}'),
                    leading: const Icon(Icons.menu_book_outlined),
                    title: Text(r.name),
                    subtitle: Text(
                      '${l10n.recipePerServing(r.servingGrams.round().toString())} · '
                      '${_nutritionLine(l10n, r)}',
                    ),
                    onTap: () => context.push('/food/${r.foodId}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: l10n.recipeEdit,
                      onPressed: () => context.push('/recipes/edit?id=${r.id}'),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Create or edit a recipe: ingredients + grams, servings and cooked yield.
class RecipeEditorScreen extends ConsumerStatefulWidget {
  const RecipeEditorScreen({super.key, this.recipeId});
  final String? recipeId;

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  final _name = TextEditingController();
  final _servings = TextEditingController(text: '1');
  final _yield = TextEditingController();
  List<RecipeIngredientLine> _lines = [];
  Recipe? _existing;

  @override
  void initState() {
    super.initState();
    final id = widget.recipeId;
    if (id != null) {
      _existing = ref.read(recipesProvider.notifier).byFoodId('${Recipe.idPrefix}$id');
      final r = _existing;
      if (r != null) {
        _name.text = r.name;
        _servings.text = r.servings.toString();
        if (r.cookedYieldGrams != null) _yield.text = r.cookedYieldGrams!.round().toString();
        _lines = [...r.ingredients];
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _servings.dispose();
    _yield.dispose();
    super.dispose();
  }

  Recipe _draft() => Recipe(
        id: _existing?.id ?? generateUuidV4(),
        name: _name.text.trim(),
        ingredients: _lines,
        servings: (int.tryParse(_servings.text) ?? 1).clamp(1, 100),
        cookedYieldGrams: double.tryParse(_yield.text),
        cuisine: _existing?.cuisine,
      );

  Future<void> _addIngredient() async {
    final food = await showDialog<Food>(
      context: context,
      builder: (_) => const FoodPickerDialog(),
    );
    if (food == null) return;
    setState(() {
      _lines = [..._lines, RecipeIngredientLine.fromFood(food, food.defaultServingGrams ?? 100)];
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final draft = _draft();
    if (draft.name.isEmpty || draft.ingredients.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.recipeNeedsIngredients)));
      return;
    }
    await ref.read(recipesProvider.notifier).upsert(draft);
    if (!mounted) return;
    _leave();
  }

  void _leave() => context.canPop() ? context.pop() : context.go('/recipes');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final draft = _draft();
    final hasMissing = draft.nutrientsPer100g.values.any((n) => n.amountPer100g == null);
    return Scaffold(
      appBar: AppBar(
        title: Text(_existing == null ? l10n.recipeNew : l10n.recipeEdit),
        actions: [
          if (_existing != null)
            IconButton(
              tooltip: l10n.recipeDelete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await ref.read(recipesProvider.notifier).delete(_existing!.id);
                if (mounted) _leave();
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('recipe-name'),
            controller: _name,
            decoration: InputDecoration(labelText: l10n.recipeName),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('recipe-servings'),
                  controller: _servings,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.recipeServings),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  key: const Key('recipe-yield'),
                  controller: _yield,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.recipeYield),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(l10n.recipeYieldHelp, style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 16),
          Text(l10n.recipeIngredients, style: Theme.of(context).textTheme.titleMedium),
          for (var i = 0; i < _lines.length; i++)
            ListTile(
              key: ValueKey('line-$i-${_lines[i].foodId}'),
              contentPadding: EdgeInsets.zero,
              title: Text(_lines[i].name),
              trailing: SizedBox(
                width: 140,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: Key('recipe-grams-$i'),
                        initialValue: _lines[i].grams.round().toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(suffixText: l10n.recipeGrams),
                        onChanged: (v) {
                          final g = double.tryParse(v);
                          if (g != null && g >= 0) {
                            setState(() => _lines[i] = _lines[i].copyWith(grams: g));
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _lines = [..._lines]..removeAt(i)),
                    ),
                  ],
                ),
              ),
            ),
          TextButton.icon(
            key: const Key('recipe-add-ingredient'),
            onPressed: _addIngredient,
            icon: const Icon(Icons.add),
            label: Text(l10n.recipeAddIngredient),
          ),
          if (_lines.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.recipePerServing(draft.servingGrams.round().toString()),
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(_nutritionLine(l10n, draft), key: const Key('recipe-summary')),
                    if (hasMissing) ...[
                      const SizedBox(height: 8),
                      Text(l10n.recipeMissingData, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            key: const Key('recipe-save'),
            onPressed: _save,
            child: Text(l10n.recipeSave),
          ),
        ],
      ),
    );
  }
}

class FoodPickerDialog extends ConsumerStatefulWidget {
  const FoodPickerDialog({super.key});

  @override
  ConsumerState<FoodPickerDialog> createState() => FoodPickerDialogState();
}

class FoodPickerDialogState extends ConsumerState<FoodPickerDialog> {
  Future<List<FoodSearchResult>> _results = Future.value(const []);

  void _search(String q) {
    setState(() {
      _results = q.trim().isEmpty
          ? Future.value(const [])
          : ref.read(foodRepositoryProvider).search(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.recipeAddIngredient),
      content: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          children: [
            TextField(
              key: const Key('recipe-ingredient-search'),
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.recipeSearchIngredient,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _search,
            ),
            Expanded(
              child: FutureBuilder<List<FoodSearchResult>>(
                future: _results,
                builder: (context, snap) => ListView(
                  children: [
                    for (final r in snap.data ?? const <FoodSearchResult>[])
                      ListTile(
                        key: Key('ingredient-result-${r.food.id}'),
                        title: Text(r.food.canonicalName),
                        subtitle: Text(
                            '${_fmt(r.food.nutrientPer100g(NutrientCode.energyKcal))} kcal / 100 g'),
                        onTap: () => Navigator.of(context).pop(r.food),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
