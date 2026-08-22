import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/storage/local_preferences.dart';

void main() {
  group('LocalPreferences list helpers', () {
    test('encodeList produces JSON array string', () {
      expect(LocalPreferences.encodeList(<String>[]), '[]');
      expect(LocalPreferences.encodeList(['a', 'b']), '["a","b"]');
    });

    test('decodeList returns empty for null or empty input', () {
      expect(LocalPreferences.decodeList(null), isEmpty);
      expect(LocalPreferences.decodeList(''), isEmpty);
    });

    test('decodeList round-trips encoded values', () {
      final encoded = LocalPreferences.encodeList(['Punjabi', 'Nigerian']);
      expect(LocalPreferences.decodeList(encoded), ['Punjabi', 'Nigerian']);
    });

    test('decodeList returns empty for malformed JSON', () {
      expect(LocalPreferences.decodeList('{not json'), isEmpty);
    });

    test('decodeList returns empty for non-array JSON', () {
      expect(LocalPreferences.decodeList('{"a":1}'), isEmpty);
    });
  });
}
