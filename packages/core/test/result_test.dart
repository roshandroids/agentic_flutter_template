import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('Ok exposes its value via dataOrNull and fold', () {
      const Result<int, Failure> result = Ok(42);

      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
      expect(result.dataOrNull, 42);
      expect(result.failureOrNull, isNull);
      expect(
        result.fold(onOk: (v) => 'ok:$v', onErr: (f) => 'err:$f'),
        'ok:42',
      );
    });

    test('Err exposes its failure via failureOrNull and fold', () {
      const failure = NotFoundFailure('missing');
      const Result<int, Failure> result = Err(failure);

      expect(result.isErr, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, failure);
      expect(
        result.fold(onOk: (v) => 'ok:$v', onErr: (f) => 'err:${f.message}'),
        'err:missing',
      );
    });

    test('map transforms Ok and leaves Err untouched', () {
      const Result<int, Failure> ok = Ok(2);
      const Result<int, Failure> err = Err(NotFoundFailure('x'));

      expect(ok.map((v) => v * 10).dataOrNull, 20);
      expect(err.map((v) => v * 10).failureOrNull, isA<NotFoundFailure>());
    });

    test('flatMap chains Ok and short-circuits on Err', () {
      const Result<int, Failure> ok = Ok(2);
      const Result<int, Failure> err = Err(NotFoundFailure('x'));

      Result<int, Failure> doubleIt(int v) => Ok(v * 2);

      expect(ok.flatMap(doubleIt).dataOrNull, 4);
      expect(err.flatMap(doubleIt).failureOrNull, isA<NotFoundFailure>());
    });

    test('Ok equality, hashCode, and toString are value-based', () {
      const a = Ok<int, Failure>(1);
      const b = Ok<int, Failure>(1);
      const c = Ok<int, Failure>(2);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(a.toString(), 'Ok(1)');
    });

    test('Err equality, hashCode, and toString are value-based', () {
      const a = Err<int, Failure>(NotFoundFailure('x'));
      const b = Err<int, Failure>(NotFoundFailure('x'));
      const c = Err<int, Failure>(NotFoundFailure('y'));

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(a.toString(), 'Err(NotFoundFailure: x)');
    });
  });
}
