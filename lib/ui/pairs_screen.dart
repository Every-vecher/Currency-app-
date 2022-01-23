import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/bloc/pairs/pairs_bloc.dart';
import 'package:test_app/bloc/rates/rates_bloc.dart';
import 'package:test_app/entities/currency_pair.dart';
import 'package:test_app/ui/widgets/dialog_widget.dart';
import 'package:test_app/ui/widgets/loading_widget.dart';
import 'package:test_app/ui/widgets/pair_widget.dart';
import 'package:test_app/utils/colors.dart';
import 'package:test_app/utils/strings.dart';

class PairsScreen extends StatelessWidget{
  static const String id = '/pairs';

  const PairsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocConsumer<PairsBloc, PairsState>(
    listener: (context, state) {
      if(state is ErrorPairsState){
        showDialog(
            context: context,
            builder: (context) => DialogWidget(
                message: state.message,
                buttonEntities: [
                  ButtonEntity(
                    title: AppStrings.ok,
                    onTap: () => Navigator.of(context).pop(),
                  )
                ]));
      }
    },
    listenWhen: (prev, current) => current is ErrorPairsState,
    buildWhen: (prev, current) => current is! ErrorPairsState,
    builder: (context, state) {
      if(state is SuccessPairsState){
        return Scaffold(
            appBar: _appBar(context, state.activePairs),
            backgroundColor: AppColors.white,
            body: SafeArea(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(color: AppColors.grey),
                  itemCount: state.pairs.length,
                  itemBuilder: (context, index) => _pair(
                      context: context,
                      pair: state.pairs[index],
                      isActive: state.activePairs.contains(state.pairs[index])
                  ),
                )));
      }

      return Loading();
    },
  );

  Widget _pair({required BuildContext context, required CurrencyPair pair, required bool isActive}) => GestureDetector(
    onTap: () => BlocProvider.of<PairsBloc>(context).changedStatePair(pair),
    child: Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PairWidget(pair: pair),
          Checkbox(
            value: isActive,
            onChanged: (_) => BlocProvider.of<PairsBloc>(context).changedStatePair(pair),
          )
        ])));

  AppBar _appBar(BuildContext context, List<CurrencyPair> pairs) => AppBar(
      title: const Text(AppStrings.titleScreens),
      actions: [
        TextButton(
          onPressed: () {
            BlocProvider.of<RatesBloc>(context).loadRates(pairs);
            Navigator.of(context).pop();
          },
          child: const Text(
            AppStrings.changed,
            style: TextStyle(
              color: AppColors.white
            ),
          ),
        )
      ]);
}