part of 'models.dart';

class ApiReturnValue<T> {
  final T? value;
  final int? value2;
  final String? message;

  ApiReturnValue({this.message, this.value, this.value2});
}
