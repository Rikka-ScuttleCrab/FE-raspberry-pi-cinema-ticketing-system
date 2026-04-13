import '../failure.dart';

class ErrorHandler {
  static Failure handle(dynamic e) {
    if (e is Failure) {
      return e;
    } else {
      return UnknownFailure("Lỗi không xác định: $e");
    }
  }
}