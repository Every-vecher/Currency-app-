import 'package:flutter/widgets.dart';
import 'package:test_app/ui/pairs_screen.dart';
import 'package:test_app/ui/rates_screen.dart';

class Navigation {
  static String getInitRoute() {
    return RatesScreen.id;
  }

  static Map<String, WidgetBuilder> getRoutes(context) => {
    RatesScreen.id: (context) => const RatesScreen(),
    PairsScreen.id: (context) => const PairsScreen(),
  };
}
