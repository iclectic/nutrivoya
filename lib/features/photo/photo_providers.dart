import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/photo_recognition.dart';
import '../../core/services/food_photo_recognizer.dart';
import '../../core/services/portion_estimation_service.dart';
import '../food/food_providers.dart';
import '../profile/profile_controller.dart';

final foodPhotoRecognizerProvider = Provider<FoodPhotoRecognizer>((ref) {
  return const SearchAssistedPhotoRecognizer();
});

final portionEstimationServiceProvider =
    Provider<PortionEstimationService>((ref) {
  return const PortionEstimationService();
});

/// Session state for the photo → suggest → portion → confirm flow.
class PhotoSessionState {
  const PhotoSessionState({
    this.imageBytes,
    this.description = '',
    this.suggestions = const [],
    this.selected,
    this.portionOptions = const [],
    this.selectedPortion,
    this.busy = false,
    this.errorKey,
  });

  final Uint8List? imageBytes;
  final String description;
  final List<PhotoFoodSuggestion> suggestions;
  final PhotoFoodSuggestion? selected;
  final List<PortionEstimate> portionOptions;
  final PortionEstimate? selectedPortion;
  final bool busy;
  final String? errorKey;

  bool get hasPhoto => imageBytes != null && imageBytes!.isNotEmpty;

  PhotoSessionState copyWith({
    Uint8List? imageBytes,
    String? description,
    List<PhotoFoodSuggestion>? suggestions,
    PhotoFoodSuggestion? selected,
    List<PortionEstimate>? portionOptions,
    PortionEstimate? selectedPortion,
    bool? busy,
    String? errorKey,
    bool clearSelected = false,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return PhotoSessionState(
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
      description: description ?? this.description,
      suggestions: suggestions ?? this.suggestions,
      selected: clearSelected ? null : (selected ?? this.selected),
      portionOptions: portionOptions ?? this.portionOptions,
      selectedPortion:
          clearSelected ? null : (selectedPortion ?? this.selectedPortion),
      busy: busy ?? this.busy,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
    );
  }
}

class PhotoSessionController extends StateNotifier<PhotoSessionState> {
  PhotoSessionController(this._ref) : super(const PhotoSessionState());

  final Ref _ref;

  void setImage(Uint8List bytes) {
    state = state.copyWith(
      imageBytes: bytes,
      suggestions: const [],
      clearSelected: true,
      clearError: true,
    );
  }

  void clearImage() {
    state = state.copyWith(
      clearImage: true,
      suggestions: const [],
      clearSelected: true,
      clearError: true,
    );
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  Future<void> runSuggestions() async {
    final bytes = state.imageBytes;
    if (bytes == null || bytes.isEmpty) {
      state = state.copyWith(errorKey: 'photoErrorNoImage');
      return;
    }
    final description = state.description.trim();
    if (description.isEmpty) {
      state = state.copyWith(errorKey: 'photoErrorNeedDescription');
      return;
    }

    state = state.copyWith(busy: true, clearError: true, clearSelected: true);
    try {
      final profile = _ref.read(profileControllerProvider);
      final repo = _ref.read(foodRepositoryProvider);
      final recognizer = _ref.read(foodPhotoRecognizerProvider);
      final suggestions = await recognizer.suggest(
        imageBytes: bytes,
        description: description,
        profile: profile,
        foodLookup: (query) async {
          final results = await repo.search(query, profile: profile);
          return results.map((r) => r.food).toList();
        },
      );
      state = state.copyWith(
        busy: false,
        suggestions: suggestions,
        errorKey: suggestions.isEmpty ? 'photoErrorNoMatches' : null,
        clearError: suggestions.isNotEmpty,
      );
    } catch (_) {
      state = state.copyWith(busy: false, errorKey: 'photoErrorFailed');
    }
  }

  void selectSuggestion(PhotoFoodSuggestion suggestion) {
    final portions =
        _ref.read(portionEstimationServiceProvider).options(suggestion.food);
    final initial =
        _ref.read(portionEstimationServiceProvider).estimate(suggestion.food);
    state = state.copyWith(
      selected: suggestion,
      portionOptions: portions,
      selectedPortion: initial,
      clearError: true,
    );
  }

  void selectPortion(PortionEstimate estimate) {
    state = state.copyWith(selectedPortion: estimate);
  }

  void reset() => state = const PhotoSessionState();
}

final photoSessionProvider =
    StateNotifierProvider.autoDispose<PhotoSessionController, PhotoSessionState>(
  (ref) => PhotoSessionController(ref),
);
