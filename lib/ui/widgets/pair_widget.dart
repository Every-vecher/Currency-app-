import 'package:flutter/material.dart';
import 'package:test_app/entities/currency_pair.dart';

class PairWidget extends StatelessWidget {
  final CurrencyPair pair;
  const PairWidget({Key? key, required this.pair}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(pair.first),
      const Icon(Icons.chevron_right),
      Text(pair.second)
    ]);
}
