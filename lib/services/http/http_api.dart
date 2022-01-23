import 'dart:convert';

import 'package:flutter_config/flutter_config.dart';
import 'package:test_app/entities/currency_pair.dart';
import 'package:test_app/entities/rate.dart';
import 'package:test_app/utils/technical_strings.dart';
import 'package:http/http.dart' as http;

part 'http_type.dart';
part 'http_params.dart';
part 'http_client.dart';
part 'http_response.dart';

/// [HttpApi] used to get request
///
/// [HttpApi.rates] used to get request rates
/// **Example**
///
/// ```
/// HttpApi api = HttpApi();
/// await api.rates(pairs: []);
/// ```
///
/// [HttpApi.pairs] used to get request pairs
/// **Example**
///
/// ```
/// HttpApi api = HttpApi();
/// await api.pairs();
/// ```
///
class HttpApi {
  final HttpClient _client;
  HttpApi() : _client = HttpClient();

  Future<dynamic> rates({required List<CurrencyPair> pairs}) async {
    List<HttpParams> params = [ HttpParams(
      title: TechnicalStrings.get,
      params: TechnicalStrings.rates,
    ), HttpParams(
      title: TechnicalStrings.pairs,
      params: List.generate(pairs.length, (index) => pairs[index].pair),
    ) ];

    HttpResponse response = await _client.request(type: GetRequest(params: params));

    if(response is SuccessResponse){
      List<Rate> rates = [];
      (response.data as Map<String, dynamic>).forEach((key, value) {
        rates.add(Rate(pair: CurrencyPair.fromPair(key), value: value));
      });
      return rates;
    }

    return response;
  }

  Future<dynamic> pairs() async {
    List<HttpParams> params = [ HttpParams(
      title: TechnicalStrings.get,
      params: TechnicalStrings.currencyList,
    )];

    HttpResponse response = await _client.request(type: GetRequest(params: params));

    if(response is SuccessResponse){
      return List.generate((response.data as List).length, (index) => CurrencyPair.fromPair((response.data as List)[index]));
    }

    return response;
  }
}