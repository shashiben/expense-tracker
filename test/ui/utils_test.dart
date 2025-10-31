import 'package:expense_tracker/ui/utils/validation_utils.dart';
import 'package:expense_tracker/ui/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ValidationUtils', () {
    test('nonEmpty', () {
      expect(ValidationUtils.nonEmpty('', fieldName: 'X')?.isNotEmpty, isTrue);
      expect(
        ValidationUtils.nonEmpty('  ', fieldName: 'X')?.isNotEmpty,
        isTrue,
      );
      expect(ValidationUtils.nonEmpty('ok', fieldName: 'X'), isNull);
    });

    test('positiveNumber', () {
      expect(
        ValidationUtils.positiveNumber('abc', fieldName: 'Amt')?.isNotEmpty,
        isTrue,
      );
      expect(
        ValidationUtils.positiveNumber('-1', fieldName: 'Amt')?.isNotEmpty,
        isTrue,
      );
      expect(
        ValidationUtils.positiveNumber('0', fieldName: 'Amt')?.isNotEmpty,
        isTrue,
      );
      expect(ValidationUtils.positiveNumber('1.5', fieldName: 'Amt'), isNull);
    });

    test('nonNull', () {
      expect(ValidationUtils.nonNull(null, fieldName: 'Y')?.isNotEmpty, isTrue);
      expect(ValidationUtils.nonNull('v', fieldName: 'Y'), isNull);
    });
  });

  group('DateUtilsX', () {
    test('formatYmd returns yyyy-MM-dd like string', () {
      final d = DateTime(2024, 7, 5);
      final s = DateUtilsX.formatYmd(d);
      expect(s.contains('2024'), isTrue);
      expect(s.contains('07') || s.contains('7'), isTrue);
      expect(s.contains('05') || s.contains('5'), isTrue);
    });

    test('formatDayMonthNameYear returns readable header', () {
      final d = DateTime(2024, 1, 1);
      final s = DateUtilsX.formatDayMonthNameYear(d);
      expect(s.toLowerCase().contains('jan'), isTrue);
      expect(s.contains('2024'), isTrue);
    });
  });
}
