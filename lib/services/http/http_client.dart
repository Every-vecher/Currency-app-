part of 'http_api.dart';


/// [HttpClient] used to realization get request and performs error handling
class HttpClient {
  final String _url = FlutterConfig.get(TechnicalStrings.url);
  final HttpParams _key = HttpParams(
    title: TechnicalStrings.key.toLowerCase(),
    params: FlutterConfig.get(TechnicalStrings.key),
  );

  Future<HttpResponse> request({required HttpType type}) async {
    try {
      http.Response response = await type.request(url: _url, key: _key);

      Map<String, dynamic> body = json.decode(response.body);

      if(body.containsKey('status')) {
        /// Можно же было statusCode передавать не в body, или хотя бы типизировать это поле.
        int statusCode = body['status'] is int ? body['status'] : int.tryParse(body['status'].toString()) ?? 0;
        if(statusCode >= 200 && statusCode < 300) {
          return SuccessResponse(body);
        }
      }

      return ErrorResponse(body);
    }
    catch (error) {
      return ErrorResponse({'message': error});
    }
  }
}