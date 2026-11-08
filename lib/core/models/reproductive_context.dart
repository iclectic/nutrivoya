/// Optional, opt-in reproductive/life-stage context.
///
/// Only offered when the user chooses it. It materially changes targets where
/// evidence supports it (e.g. no energy deficit during pregnancy, extra energy
/// during lactation) and never becomes a required field.
enum ReproductiveContext {
  none,
  pregnant,
  breastfeeding,
  postpartum,
  perimenopause,
  menopause,
}

extension ReproductiveContextX on ReproductiveContext {
  String get id => name;

  /// Whether an energy deficit should be blocked for safety.
  bool get blocksDeficit =>
      this == ReproductiveContext.pregnant ||
      this == ReproductiveContext.breastfeeding;

  static ReproductiveContext fromId(String? id) {
    return ReproductiveContext.values.firstWhere(
      (e) => e.id == id,
      orElse: () => ReproductiveContext.none,
    );
  }
}
