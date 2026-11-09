import '../../../core/models/food.dart';

/// Tier 2 — packaged / barcode food lookup.
///
/// Crowdsourced entries are never assumed perfectly accurate. Callers should
/// surface source + confidence to the user before logging.
abstract class PackagedFoodRepository {
  /// Look up a packaged product by barcode (EAN/UPC).
  ///
  /// Returns `null` when the product is not found. Throws [NetworkError] on
  /// transport failures so the UI can distinguish "not found" from offline.
  Future<Food?> lookupBarcode(String barcode);
}

/// Normalizes barcode input: digits only, common lengths 8–14.
String? normalizeBarcode(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 8 || digits.length > 14) return null;
  return digits;
}

bool looksLikeBarcode(String query) {
  final digits = query.replaceAll(RegExp(r'\D'), '');
  return digits.length >= 8 &&
      digits.length <= 14 &&
      digits == query.replaceAll(RegExp(r'\s'), '');
}
