import 'package:flutter/material.dart';

import '../../core/models/food.dart';
import '../../core/models/food_portion.dart';
import '../../shared/extensions/app_localizations_x.dart';

/// Lets the user pick a portion (culturally meaningful or custom grams) and a
/// quantity, then live-computes the nutrition for the selected grams.
class PortionSelector extends StatefulWidget {
  const PortionSelector({
    super.key,
    required this.food,
    required this.onChanged,
  });

  final Food food;
  final ValueChanged<PortionSelection> onChanged;

  @override
  State<PortionSelector> createState() => _PortionSelectorState();
}

class PortionSelection {
  const PortionSelection({
    required this.grams,
    this.portion,
    this.quantity = 1,
  });

  /// Total grams consumed (portion grams × quantity, or custom grams).
  final double grams;
  final FoodPortion? portion;
  final int quantity;
}

class _PortionSelectorState extends State<PortionSelector> {
  int _selectedPortionIndex = 0;
  bool _customGrams = false;
  double _grams = 100;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _initSelection();
  }

  void _initSelection() {
    if (widget.food.portions.isNotEmpty) {
      _grams = widget.food.portions.first.grams;
    } else {
      _grams = widget.food.defaultServingGrams ?? 100;
      _customGrams = true;
    }
  }

  double get _totalGrams => _customGrams ? _grams : _grams * _quantity;

  void _emit() {
    widget.onChanged(PortionSelection(
      grams: _totalGrams,
      portion: _customGrams ? null : widget.food.portions[_selectedPortionIndex],
      quantity: _quantity,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.portionLabel, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (widget.food.portions.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < widget.food.portions.length; i++)
                ChoiceChip(
                  label: Text(widget.food.portions[i].name),
                  selected: !_customGrams && _selectedPortionIndex == i,
                  onSelected: (selected) {
                    if (!selected) return;
                    setState(() {
                      _customGrams = false;
                      _selectedPortionIndex = i;
                      _grams = widget.food.portions[i].grams;
                      _quantity = 1;
                    });
                    _emit();
                  },
                ),
              ChoiceChip(
                label: Text(l10n.portionCustom),
                selected: _customGrams,
                onSelected: (selected) {
                  if (!selected) return;
                  setState(() {
                    _customGrams = true;
                    _grams = widget.food.defaultServingGrams ?? 100;
                    _quantity = 1;
                  });
                  _emit();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        if (!_customGrams) ...[
          Row(
            children: [
              Text(l10n.portionQuantity),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _quantity > 1
                    ? () {
                        setState(() => _quantity--);
                        _emit();
                      }
                    : null,
              ),
              Text('$_quantity',
                  style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _quantity < 20
                    ? () {
                        setState(() => _quantity++);
                        _emit();
                      }
                    : null,
              ),
            ],
          ),
        ] else ...[
          Row(
            children: [
              Text(l10n.portionGrams),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  min: 5,
                  max: 500,
                  divisions: 99,
                  value: _grams.clamp(5, 500),
                  label: '${_grams.round()} g',
                  onChanged: (v) {
                    setState(() => _grams = v);
                    _emit();
                  },
                ),
              ),
              SizedBox(
                width: 64,
                child: Text('${_grams.round()} g',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Text(
          '${l10n.foodDetailsPerPortion}: ${_totalGrams.round()} g',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
