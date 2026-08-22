/// Physiological calculation input, kept deliberately separate from gender
/// identity.
///
/// Energy-requirement equations (e.g. Mifflin-St Jeor) historically use a
/// binary sex parameter. Nutrivoya treats this as a calculation input only and
/// offers a "prefer not to say" option; when unset, calculations fall back to
/// a neutral estimate and clearly communicate lower confidence.
enum PhysiologicalInput {
  female,
  male,
  unspecified,
}

extension PhysiologicalInputX on PhysiologicalInput {
  String get id => name;

  String get l10nKey {
    switch (this) {
      case PhysiologicalInput.female:
        return 'onboardingSexFemale';
      case PhysiologicalInput.male:
        return 'onboardingSexMale';
      case PhysiologicalInput.unspecified:
        return 'onboardingSexPreferNotToSay';
    }
  }

  static PhysiologicalInput fromId(String id) {
    return PhysiologicalInput.values.firstWhere(
      (e) => e.id == id,
      orElse: () => PhysiologicalInput.unspecified,
    );
  }
}
