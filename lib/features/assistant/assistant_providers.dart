import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/assistant_models.dart';
import '../../core/models/diary_entry.dart';
import '../../core/services/nutrition_assistant_service.dart';
import '../diary/diary_providers.dart';
import '../food/food_providers.dart';
import '../goals/goals_providers.dart';
import '../profile/profile_controller.dart';

final nutritionAssistantServiceProvider =
    Provider<NutritionAssistantService>((ref) {
  return const NutritionAssistantService();
});

/// Chat turn stored for the Ask Nutrivoya session.
class AssistantTurn {
  const AssistantTurn({
    required this.question,
    required this.answer,
  });

  final String question;
  final AssistantAnswer answer;
}

class AssistantController extends StateNotifier<List<AssistantTurn>> {
  AssistantController(this._ref) : super(const []);

  final Ref _ref;

  Future<void> ask(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return;

    final profile = _ref.read(profileControllerProvider);
    final targets = _ref.read(nutritionTargetsProvider);
    final totals = _ref.read(dailyTotalsProvider).asData?.value;
    final entries = _ref.read(diaryEntriesProvider).asData?.value ??
        const <DiaryEntry>[];

    final context = AssistantContext(
      profile: profile,
      targets: targets,
      todayTotals: totals,
      todayEntries: entries,
      familiarCuisines: profile?.familiarCuisines ?? const [],
    );

    final repo = _ref.read(foodRepositoryProvider);
    final service = _ref.read(nutritionAssistantServiceProvider);

    final answer = await service.answer(
      trimmed,
      context: context,
      foodLookup: (query) async {
        final results = await repo.search(query, profile: profile);
        return results.map((r) => r.food).toList();
      },
    );

    state = [...state, AssistantTurn(question: trimmed, answer: answer)];
  }

  void clear() => state = const [];
}

final assistantControllerProvider =
    StateNotifierProvider<AssistantController, List<AssistantTurn>>(
  (ref) => AssistantController(ref),
);
