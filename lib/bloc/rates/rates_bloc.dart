import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/entities/currency_pair.dart';
import 'package:test_app/entities/rate.dart';
import 'package:test_app/services/http/http_api.dart';
import 'package:test_app/utils/strings.dart';

part 'rates_state.dart';

/// [RatesBloc] used to state management
///
/// [RatesBloc._timerFunction] used to control update for 10 minutes
///
/// [RatesBloc.update] used to updating the value of currency pairs
///
/// **Example**
/// ```
/// await BlocProvider.of<RatesBloc>(context).update()
/// ```
///
/// [RatesBloc.loadRates] used to downloads of all currencies
///
/// **Example**
/// ```
/// BlocProvider.of<RatesBloc>(context).loadRates([])
/// ```
///
/// [RatesBloc.deleteRate] used to delete currencies
///
/// **Example**
/// ```
/// BlocProvider.of<RatesBloc>(context).deleteRate()
/// ```
class RatesBloc extends Cubit<RatesState> {
  final HttpApi _api;
  RatesBloc({HttpApi? api})
      : _api = api ?? GetIt.instance<HttpApi>(),
        super(SuccessRatesState(rates: const [])){
    timer = Timer.periodic(const Duration(minutes: 10), _timerFunction);
  }

  Timer? timer;

  void _timerFunction(Timer timer) {
    RatesState state = this.state;
    if(state is SuccessRatesState && state.rates.isNotEmpty){
      update();
    }
  }

  Future<void> update() async {
    RatesState state = this.state;
    if(state is SuccessRatesState){
      List<CurrencyPair> pairs = List.generate(state.rates.length, (index) => state.rates[index].pair);
      await loadRates(pairs);
    }
  }

  Future<void> loadRates(List<CurrencyPair> pairs) async {
    RatesState state = this.state;

    dynamic rates = await _api.rates(pairs: pairs);

    if(rates is List<Rate>) {
      emit(SuccessRatesState(rates: rates));
    }
    else{
      emit(ErrorRatesState((rates as ErrorResponse).data.toString()));

      if(state is SuccessRatesState){
        emit(state);
      }
    }
  }

  void deleteRate(Rate rate) {
    RatesState state = this.state;
    if(state is SuccessRatesState) {
      List<Rate> rates = List.of(state.rates);
      rates.remove(rate);

      emit(SuccessRatesState(rates: rates));
    }
    else{
      emit(ErrorRatesState(AppStrings.errorMessageRates));
      emit(state);
    }
  }
}
