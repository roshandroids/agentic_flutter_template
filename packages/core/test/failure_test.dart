import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('Failure', () {
    test('NetworkFailure equality includes statusCode', () {
      expect(
        const NetworkFailure('timeout', statusCode: 504),
        const NetworkFailure('timeout', statusCode: 504),
      );
      expect(
        const NetworkFailure('timeout', statusCode: 504),
        isNot(const NetworkFailure('timeout', statusCode: 500)),
      );
    });

    test('ValidationFailure equality includes fieldErrors', () {
      expect(
        const ValidationFailure('invalid', fieldErrors: {'email': 'required'}),
        const ValidationFailure('invalid', fieldErrors: {'email': 'required'}),
      );
      expect(
        const ValidationFailure('invalid', fieldErrors: {'email': 'required'}),
        isNot(const ValidationFailure('invalid', fieldErrors: {})),
      );
    });

    test('toString includes the runtime type for log readability', () {
      expect(
        const NotFoundFailure('missing').toString(),
        'NotFoundFailure: missing',
      );
    });

    test('NotFoundFailure equality and hashCode are message-based', () {
      expect(const NotFoundFailure('gone'), const NotFoundFailure('gone'));
      expect(
        const NotFoundFailure('gone').hashCode,
        const NotFoundFailure('gone').hashCode,
      );
      expect(const NotFoundFailure('gone'), isNot(const NotFoundFailure('x')));
    });

    test('UnauthorizedFailure equality and hashCode are message-based', () {
      expect(
        const UnauthorizedFailure('expired'),
        const UnauthorizedFailure('expired'),
      );
      expect(
        const UnauthorizedFailure('expired').hashCode,
        const UnauthorizedFailure('expired').hashCode,
      );
      expect(
        const UnauthorizedFailure('expired'),
        isNot(const UnauthorizedFailure('x')),
      );
    });

    test('UnexpectedFailure equality and hashCode include cause', () {
      final cause = Exception('boom');
      expect(
        UnexpectedFailure('oops', cause: cause),
        UnexpectedFailure('oops', cause: cause),
      );
      expect(
        UnexpectedFailure('oops', cause: cause).hashCode,
        UnexpectedFailure('oops', cause: cause).hashCode,
      );
      expect(
        const UnexpectedFailure('oops'),
        isNot(UnexpectedFailure('oops', cause: cause)),
      );
    });

    test('NetworkFailure hashCode matches for equal instances', () {
      expect(
        const NetworkFailure('timeout', statusCode: 504).hashCode,
        const NetworkFailure('timeout', statusCode: 504).hashCode,
      );
    });

    test('ValidationFailure hashCode matches for equal instances', () {
      expect(
        const ValidationFailure(
          'invalid',
          fieldErrors: {'email': 'required'},
        ).hashCode,
        const ValidationFailure(
          'invalid',
          fieldErrors: {'email': 'required'},
        ).hashCode,
      );
    });

    test(
      'ValidationFailure is not equal when fieldErrors have different lengths',
      () {
        expect(
          const ValidationFailure('invalid', fieldErrors: {'a': '1'}),
          isNot(
            const ValidationFailure(
              'invalid',
              fieldErrors: {'a': '1', 'b': '2'},
            ),
          ),
        );
      },
    );
  });
}
