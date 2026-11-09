import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/food.dart';
import '../food/data/open_food_facts_adapter.dart';
import '../food/data/packaged_food_repository.dart';

final openFoodFactsAdapterProvider = Provider<OpenFoodFactsAdapter>((ref) {
  return OpenFoodFactsAdapter();
});

final packagedFoodRepositoryProvider = Provider<PackagedFoodRepository>((ref) {
  return ref.watch(openFoodFactsAdapterProvider);
});

/// Lookup state for a barcode scan / manual entry.
sealed class BarcodeLookupState {
  const BarcodeLookupState();
}

class BarcodeLookupIdle extends BarcodeLookupState {
  const BarcodeLookupIdle();
}

class BarcodeLookupLoading extends BarcodeLookupState {
  const BarcodeLookupLoading(this.barcode);
  final String barcode;
}

class BarcodeLookupFound extends BarcodeLookupState {
  const BarcodeLookupFound(this.food);
  final Food food;
}

class BarcodeLookupNotFound extends BarcodeLookupState {
  const BarcodeLookupNotFound(this.barcode);
  final String barcode;
}

class BarcodeLookupError extends BarcodeLookupState {
  const BarcodeLookupError(this.messageKey, {this.detail});
  final String messageKey;
  final String? detail;
}

class BarcodeLookupController extends StateNotifier<BarcodeLookupState> {
  BarcodeLookupController(this._repo) : super(const BarcodeLookupIdle());

  final PackagedFoodRepository _repo;

  Future<void> lookup(String rawBarcode) async {
    final code = normalizeBarcode(rawBarcode);
    if (code == null) {
      state = const BarcodeLookupError('barcodeInvalid');
      return;
    }

    state = BarcodeLookupLoading(code);
    try {
      final food = await _repo.lookupBarcode(code);
      if (food == null) {
        state = BarcodeLookupNotFound(code);
      } else {
        state = BarcodeLookupFound(food);
      }
    } catch (e) {
      state = BarcodeLookupError(
        'barcodeNetworkError',
        detail: e.toString(),
      );
    }
  }

  void reset() => state = const BarcodeLookupIdle();
}

final barcodeLookupControllerProvider =
    StateNotifierProvider.autoDispose<BarcodeLookupController, BarcodeLookupState>(
  (ref) => BarcodeLookupController(ref.watch(packagedFoodRepositoryProvider)),
);
