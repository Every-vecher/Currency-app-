part of 'rates_bloc.dart';

abstract class RatesState extends Equatable {}

class SuccessRatesState extends RatesState {
  final List<Rate> rates;
  SuccessRatesState({required this.rates});

  @override
  List<Object> get props => [rates];
}

class ErrorRatesState extends RatesState{
  final String message;
  ErrorRatesState(this.message);

  @override
  List<Object> get props => [message];
}