part of 'pairs_bloc.dart';

abstract class PairsState extends Equatable {}

class LoadingPairsState extends PairsState {
  @override
  List<Object?> get props => [];
}

class SuccessPairsState extends PairsState {
  final List<CurrencyPair> pairs;
  final List<CurrencyPair> activePairs;
  SuccessPairsState({required this.pairs, required this.activePairs});

  @override
  List<Object> get props => [pairs, activePairs];
}

class ErrorPairsState extends PairsState{
  final String message;
  ErrorPairsState(this.message);

  @override
  List<Object> get props => [message];
}