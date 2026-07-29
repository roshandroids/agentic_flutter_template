import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:network/network.dart';
import 'package:test/test.dart';

DioException _exception({
  required DioExceptionType type,
  int? statusCode,
  dynamic data,
}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: type,
    response: statusCode == null
        ? null
        : Response<dynamic>(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
  );
}

void main() {
  group('mapDioExceptionToFailure', () {
    test('connectionError maps to NetworkFailure', () {
      final failure = mapDioExceptionToFailure(
        _exception(type: DioExceptionType.connectionError),
      );
      expect(failure, isA<NetworkFailure>());
    });

    test('401 maps to UnauthorizedFailure', () {
      final failure = mapDioExceptionToFailure(
        _exception(
          type: DioExceptionType.badResponse,
          statusCode: 401,
          data: {'message': 'token expired'},
        ),
      );
      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'token expired');
    });

    test('404 maps to NotFoundFailure', () {
      final failure = mapDioExceptionToFailure(
        _exception(type: DioExceptionType.badResponse, statusCode: 404),
      );
      expect(failure, isA<NotFoundFailure>());
    });

    test('422 maps to ValidationFailure with field errors', () {
      final failure = mapDioExceptionToFailure(
        _exception(
          type: DioExceptionType.badResponse,
          statusCode: 422,
          data: {
            'message': 'invalid',
            'errors': {'email': 'required'},
          },
        ),
      );
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).fieldErrors, {'email': 'required'});
    });

    test('unmapped 5xx falls back to NetworkFailure with status code', () {
      final failure = mapDioExceptionToFailure(
        _exception(type: DioExceptionType.badResponse, statusCode: 503),
      );
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).statusCode, 503);
    });

    test('badCertificate maps to NetworkFailure', () {
      final failure = mapDioExceptionToFailure(
        _exception(type: DioExceptionType.badCertificate),
      );
      expect(failure, isA<NetworkFailure>());
    });

    test('cancel maps to a fixed NetworkFailure message', () {
      final failure = mapDioExceptionToFailure(
        _exception(type: DioExceptionType.cancel),
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'Request was cancelled');
    });

    test('unknown maps to UnexpectedFailure carrying the original error', () {
      final options = RequestOptions(path: '/x');
      final original = Exception('weird');
      final exception = DioException(
        requestOptions: options,
        type: DioExceptionType.unknown,
        error: original,
      );

      final failure = mapDioExceptionToFailure(exception);

      expect(failure, isA<UnexpectedFailure>());
      expect((failure as UnexpectedFailure).cause, original);
    });
  });
}
