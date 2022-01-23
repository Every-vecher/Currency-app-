import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app/entities/currency_pair.dart';
import 'package:test_app/services/http/http_api.dart';
import 'package:test_app/utils/strings.dart';

part 'pairs_state.dart';

/// [PairsBloc] used to state management
///
/// [PairsBloc.loadPairs] used to downloads of currency pairs
/// **Example**
/// ```
/// BlocProvider.of<PairsBloc>(context).loadPairs([]))
/// ```
///
/// [PairsBloc.changedStatePair] used to changes in the state of a particular currency pair
/// **Example**
/// ```
/// BlocProvider.of<PairsBloc>(context).changedStatePair(pair)
/// ```
class PairsBloc extends Cubit<PairsState> {
  final HttpApi _api;
  PairsBloc({HttpApi? api})
      : _api = api ?? GetIt.I<HttpApi>(),
        super(SuccessPairsState(pairs: [], activePairs: []));

  void loadPairs(List<CurrencyPair> activePairs) async {
    PairsState state = this.state;
    emit(LoadingPairsState());

    dynamic pairs = await _api.pairs();

    if(pairs is List<CurrencyPair>) {
      List<CurrencyPair> newActivePairs = [];
      for (var pair in activePairs) {
        if(pairs.contains(pair)) {
          newActivePairs.add(pair);
        }
      }

      emit(SuccessPairsState(pairs: pairs, activePairs: newActivePairs));
    }
    else{
      emit(ErrorPairsState((pairs as ErrorResponse).data.toString()));

      if(state is SuccessPairsState){
        emit(state);
      }
    }
  }

  void changedStatePair(CurrencyPair pair) {
    List<CurrencyPair> activePairs = [];
    PairsState state = this.state;
    if(state is SuccessPairsState){
      activePairs.addAll(state.activePairs);
      if(activePairs.contains(pair)) {
        activePairs.remove(pair);
      }
      else {
        activePairs.add(pair);
      }

      emit(SuccessPairsState(pairs: state.pairs, activePairs: activePairs));
    }
    else{
      PairsState state = this.state;
      emit(ErrorPairsState(AppStrings.errorMessagePairs));

      if(state is SuccessPairsState){
        emit(state);
      }
    }
  }
}
