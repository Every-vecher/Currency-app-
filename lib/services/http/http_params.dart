part of 'http_api.dart';

/// [HttpParams] used to transmission request
class HttpParams {
  final String title;
  final dynamic params;

  HttpParams({required this.title, required this.params});

  @override
  String toString() => '{ title: $title, params: $params }';
}