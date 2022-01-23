part of 'http_api.dart';

/// [HttpApi] for request type design
///
/// **Example**
/// ```
/// HttpType type = HttpType([]);
/// await type.request(url: ‘url’, key: HttpParams(title: ‘key’, params: ‘value’);
/// ```
///
abstract class HttpType{
  final List<HttpParams> params;
  HttpType(this.params);

  Future<dynamic> request({required String url, required HttpParams key});
}

/// [GetRequest.request] executes GET request
class GetRequest extends HttpType {
  GetRequest({required List<HttpParams> params}) : super(params);

  @override
  Future request({required String url, required HttpParams key}) async {
    String _params = '';
    for(int index = 0; index < params.length; index++){
      if(_params.isNotEmpty) {
        _params += '&';
      }

      _params += params[index].title + '=';

      switch (params[index].params.runtimeType) {
        case String:
        case int:
        case double:
        case bool:
          _params += params[index].params.toString();
          break;
        case List<String>:
          List<String> list = params[index].params;
          for(int indexList = 0; indexList < list.length; indexList++){
            if(indexList != 0) {
              _params += ',';
            }

            _params += list[indexList];
          }
          break;
        default:
          throw Exception('Error params: $params');
      }
    }
    if(_params.isNotEmpty) {
      _params += '&';
    }
    _params += key.title + '=' + key.params;

    return await http.get(Uri.parse(url + '?' + _params));
  }
}