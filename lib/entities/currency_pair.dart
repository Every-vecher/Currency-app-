import 'package:equatable/equatable.dart';

/// [CurrencyPair] used to split a string into two substrings
class CurrencyPair extends Equatable{
  final String first;
  final String second;

  const CurrencyPair({required this.first, required this.second});
  factory CurrencyPair.fromPair(String pair) => CurrencyPair(
    first: pair.substring(0, 3),
    second: pair.substring(3),
  );

  String get pair => first + second;

  @override
  List<Object?> get props => [pair];
}