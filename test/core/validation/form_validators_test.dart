import 'package:flutter_test/flutter_test.dart';
import 'package:kiray_bet/core/validation/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('requires a non-empty name', () {
      expect(FormValidators.name('  ', requiredMessage: 'Required'), isNotNull);
      expect(FormValidators.name('Hana', requiredMessage: 'Required'), isNull);
    });

    test('checks email format', () {
      expect(
        FormValidators.email(
          '',
          requiredMessage: 'Required',
          invalidMessage: 'Invalid',
        ),
        isNotNull,
      );
      expect(
        FormValidators.email(
          'not-an-email',
          requiredMessage: 'Required',
          invalidMessage: 'Invalid',
        ),
        isNotNull,
      );
      expect(
        FormValidators.email(
          'hana@example.com',
          requiredMessage: 'Required',
          invalidMessage: 'Invalid',
        ),
        isNull,
      );
    });

    test('requires passwords of at least six characters', () {
      expect(
        FormValidators.password(
          '12345',
          requiredMessage: 'Required',
          shortMessage: 'Short',
        ),
        isNotNull,
      );
      expect(
        FormValidators.password(
          '123456',
          requiredMessage: 'Required',
          shortMessage: 'Short',
        ),
        isNull,
      );
    });

    test('accepts the supported Ethiopian phone formats', () {
      expect(
        FormValidators.phone(
          '+251912345678',
          requiredMessage: 'Required',
          invalidMessage: 'Invalid',
        ),
        isNull,
      );
      expect(
        FormValidators.phone(
          '0912345678',
          requiredMessage: 'Required',
          invalidMessage: 'Invalid',
        ),
        isNull,
      );
      expect(
        FormValidators.phone(
          '0712345678',
          requiredMessage: 'Required',
          invalidMessage: 'Invalid',
        ),
        isNotNull,
      );
    });
  });
}
