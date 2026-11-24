/// Optional reproductive context, stored only when the user opts in.
///
/// Nutrivoya does not infer pregnancy or breastfeeding. The default is
/// [none]. When set, aggressive weight-loss calorie targets are not applied.
enum ReproductiveContext {
  none,
  pregnant,
  breastfeeding,
}

extension ReproductiveContextX on ReproductiveContext {
  String get id => name;

  String get l10nKey {
    switch (this) {
      case ReproductiveContext.none:
        return 'onboardingReproductiveNone';
      case ReproductiveContext.pregnant:
        return 'onboardingReproductivePregnant';
      case ReproductiveContext.breastfeeding:
        return 'onboardingReproductiveBreastfeeding';
    }
  }

  static ReproductiveContext fromId(String? id) {
    return ReproductiveContext.values.firstWhere(
      (e) => e.id == id,
      orElse: () => ReproductiveContext.none,
    );
  }
}
