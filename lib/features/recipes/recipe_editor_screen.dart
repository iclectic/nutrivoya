import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/food.dart';
import '../../core/models/nutrient.dart';
import '../../core/models/recipe_ingredient.dart';
import '../../shared/extensions/app_localizations_x.dart';
import '../food/food_providers.dart';
import 'recipe_providers.dart';

/// Create or edit a personal recipe and calculate nutrition from ingredients.
class RecipeEditorScreen extends ConsumerStatefulWidget {
  const RecipeEditorScreen({super.key, this.recipeId});

  final String? recipeId;

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  final _nameCtrl = TextEditingController();
  final _servingsCtrl = TextEditingController(text: '4');
  final _yieldCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _ingredients = <RecipeIngredient>[];
  String? _existingId;
  DateTime? _createdAt;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _servingsCtrl.dispose();
    _yieldCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (!_initialized && widget.recipeId != null) {
      final existing = ref.watch(recipeByIdProvider(widget.recipeId!));
      if (existing != null) {
        _existingId = existing.id;
        _createdAt = existing.createdAt;
        _nameCtrl.text = existing.name;
        _servingsCtrl.text = '${existing.servings}';
        _yieldCtrl.text = existing.totalWeightGrams.toStringAsFixed(0);
        _notesCtrl.text = existing.notes ?? '';
        _ingredients
          ..clear()
          ..addAll(existing.ingredients);
        _initialized = true;
      }
    } else if (!_initialized) {
      _initialized = true;
    }

    final preview = _ingredients.isEmpty
        ? null
        : ref.read(recipeNutritionServiceProvider).build(
              id: _existingId ?? 'draft',
              name: _nameCtrl.text,
              ingredients: _ingredients,
              servings: int.tryParse(_servingsCtrl.text) ?? 1,
              totalWeightGrams: double.tryParse(_yieldCtrl.text),
              notes: _notesCtrl.text,
              createdAt: _createdAt,
            );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipeId == null ? l10n.recipesCreate : l10n.recipesEdit,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: l10n.recipesNameLabel),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _servingsCtrl,
                    decoration:
                        InputDecoration(labelText: l10n.recipesServingsLabel),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _yieldCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.recipesYieldLabel,
                      hintText: l10n.recipesYieldHint,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.recipesIngredients,
                    style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: _addIngredient,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.recipesAddIngredient),
                ),
              ],
            ),
            if (_ingredients.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  l10n.recipesIngredientsEmpty,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              )
            else
              ..._ingredients.asMap().entries.map((entry) {
                final i = entry.key;
                final ingredient = entry.value;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(ingredient.foodName),
                  subtitle: Text('${ingredient.grams.toStringAsFixed(0)} g'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() => _ingredients.removeAt(i)),
                  ),
                );
              }),
            const SizedBox(height: 12),
            TextField(
              controller: _notesCtrl,
              decoration: InputDecoration(labelText: l10n.recipesNotesLabel),
              maxLines: 2,
            ),
            if (preview != null) ...[
              const SizedBox(height: 24),
              Text(l10n.recipesCalculatedNutrition,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.recipesWholeRecipeKcal(
                          (preview.nutrientsPer100g[NutrientCode.energyKcal] ==
                                  null)
                              ? 0
                              : ((preview.nutrientsPer100g[
                                              NutrientCode.energyKcal]! /
                                          100) *
                                      preview.totalWeightGrams)
                                  .round(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.recipesPerServingKcal(
                          preview.caloriesPerServing?.round() ?? 0,
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.onboardingSummaryMacros(
                          preview
                                  .nutrientPerServing(NutrientCode.proteinG)
                                  ?.round() ??
                              0,
                          preview
                                  .nutrientPerServing(
                                      NutrientCode.carbohydrateG)
                                  ?.round() ??
                              0,
                          preview
                                  .nutrientPerServing(NutrientCode.fatG)
                                  ?.round() ??
                              0,
                          preview
                                  .nutrientPerServing(NutrientCode.fibreG)
                                  ?.round() ??
                              0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.recipesCalculationNote,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _ingredients.isEmpty || _nameCtrl.text.trim().isEmpty
                  ? null
                  : _save,
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addIngredient() async {
    final l10n = context.l10n;
    final food = await showModalBottomSheet<Food>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _IngredientPickerSheet(),
    );
    if (food == null || !mounted) return;

    final gramsCtrl = TextEditingController(
      text: (food.defaultServingGrams ?? 100).toStringAsFixed(0),
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food.displayName),
        content: TextField(
          controller: gramsCtrl,
          decoration: InputDecoration(labelText: l10n.diaryGramsLabel),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    final grams = double.tryParse(gramsCtrl.text);
    gramsCtrl.dispose();
    if (confirmed != true || grams == null || grams <= 0) return;

    setState(() {
      _ingredients.add(
        RecipeIngredient(
          foodId: food.id,
          foodName: food.displayName,
          grams: grams,
          nutrientsPer100g: {
            for (final e in food.nutrientsPer100g.entries)
              e.key: e.value.amountPer100g,
          },
        ),
      );
      if (_yieldCtrl.text.trim().isEmpty) {
        final total =
            _ingredients.fold<double>(0, (sum, i) => sum + i.grams);
        _yieldCtrl.text = total.toStringAsFixed(0);
      }
    });
  }

  Future<void> _save() async {
    final id = _existingId ??
        'recipe-${DateTime.now().toUtc().millisecondsSinceEpoch}';
    final recipe = ref.read(recipeNutritionServiceProvider).build(
          id: id,
          name: _nameCtrl.text,
          ingredients: _ingredients,
          servings: int.tryParse(_servingsCtrl.text) ?? 1,
          totalWeightGrams: double.tryParse(_yieldCtrl.text),
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
          createdAt: _createdAt,
          updatedAt: DateTime.now().toUtc(),
        );
    await ref.read(recipeControllerProvider).save(recipe);
    if (mounted) context.go('/recipes/${recipe.id}');
  }
}

class _IngredientPickerSheet extends ConsumerStatefulWidget {
  const _IngredientPickerSheet();

  @override
  ConsumerState<_IngredientPickerSheet> createState() =>
      _IngredientPickerSheetState();
}

class _IngredientPickerSheetState
    extends ConsumerState<_IngredientPickerSheet> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final q = _query.text.trim();
    // Use repository search directly for the sheet.
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(l10n.recipesAddIngredient,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _query,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder(
                  future: q.isEmpty
                      ? Future.value(const [])
                      : ref.read(foodRepositoryProvider).search(q),
                  builder: (context, snapshot) {
                    final results = snapshot.data ?? const [];
                    if (q.isEmpty) {
                      return Center(child: Text(l10n.searchEmpty));
                    }
                    if (results.isEmpty) {
                      return Center(child: Text(l10n.searchNoResults));
                    }
                    return ListView.builder(
                      controller: controller,
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final food = results[index].food;
                        return ListTile(
                          title: Text(food.displayName),
                          subtitle: Text(food.canonicalName),
                          onTap: () => Navigator.pop(context, food),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
