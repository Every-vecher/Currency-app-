part of 'http_api.dart';
/// [HttpResponse] used to convert response
abstract class HttpResponse {
  final dynamic data;
  HttpResponse(this.data);
}

/// [SuccessResponse] used to successful response
class SuccessResponse extends HttpResponse{
  SuccessResponse(Map<String, dynamic> map) : super(map['data']);
}

/// [ErrorResponse] used to erroneous response
class ErrorResponse extends HttpResponse{
  ErrorResponse(Map<String, dynamic> map) : super(map['message']);
}