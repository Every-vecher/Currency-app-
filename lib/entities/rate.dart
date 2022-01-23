import 'package:test_app/entities/currency_pair.dart';

/// [Rate] used to currency pair descriptions
class Rate {
  final CurrencyPair pair;
  final String value;

  Rate({required this.pair, required this.value});
  factory Rate.fromMap(String pair, String value) => Rate(
    pair: CurrencyPair.fromPair(pair),
    value: value,
  );
}