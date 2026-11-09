import 'package:flutter_test/flutter_test.dart';
import 'package:nutrivoya/core/models/food_name.dart';

void main() {
  group('FoodName.normalize', () {
    test('lowercases and collapses whitespace', () {
      expect(FoodName.normalize('  Roti   Chapati '), 'roti chapati');
    });

    test('folds common Latin diacritics', () {
      expect(FoodName.normalize('crème brûlée'), 'creme brulee');
      expect(FoodName.normalize('jalapeño'), 'jalapeno');
    });

    test('strips combining marks', () {
      // e + combining acute accent
      expect(FoodName.normalize('e\u0301'), 'e');
    });

    test('keeps non-Latin scripts intact', () {
      expect(FoodName.normalize('दाल'), 'दाल');
      expect(FoodName.normalize('دہی'), 'دہی');
      expect(FoodName.normalize('비빔밥'), '비빔밥');
    });
  });
}
