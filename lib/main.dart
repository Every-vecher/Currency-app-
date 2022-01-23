import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/bloc/pairs/pairs_bloc.dart';
import 'package:test_app/bloc/rates/rates_bloc.dart';
import 'package:test_app/init.dart';
import 'package:test_app/navigation.dart';
import 'package:test_app/ui/widgets/loading_widget.dart';
import 'package:test_app/utils/strings.dart';

void main() {
  runZonedGuarded(() {
    runApp(FutureBuilder(
        future: Init.initialize(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const TestApp();
          } else {
            return Loading();
          }
        }));
  }, (error, stackTrace) => print('error: $error\nstackTrace: $stackTrace'));
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RatesBloc>(create: (context) => RatesBloc()),
        BlocProvider<PairsBloc>(create: (context) => PairsBloc()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Navigation.getInitRoute(),
        routes: Navigation.getRoutes(context),
      ),
    );
  }
}