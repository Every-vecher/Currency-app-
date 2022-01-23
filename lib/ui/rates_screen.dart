import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_app/bloc/pairs/pairs_bloc.dart';
import 'package:test_app/bloc/rates/rates_bloc.dart';
import 'package:test_app/entities/rate.dart';
import 'package:test_app/ui/pairs_screen.dart';
import 'package:test_app/ui/widgets/dialog_widget.dart';
import 'package:test_app/ui/widgets/loading_widget.dart';
import 'package:test_app/ui/widgets/pair_widget.dart';
import 'package:test_app/utils/colors.dart';
import 'package:test_app/utils/strings.dart';

class RatesScreen extends StatelessWidget{
  static const String id = '/rates';

  const RatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocConsumer<RatesBloc, RatesState>(
    listener: (context, state) {
      if(state is ErrorRatesState){
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
    listenWhen: (prev, current) => current is ErrorRatesState,
    buildWhen: (prev, current) => current is! ErrorRatesState,
    builder: (context, state) {
      if(state is SuccessRatesState){
        return Scaffold(
          appBar: _appBar(context, state.rates),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => await BlocProvider.of<RatesBloc>(context).update(),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(color: AppColors.grey),
                itemCount: state.rates.length,
                itemBuilder: (context, index) => _pair(state.rates[index],  context),
              ))));
      }

      return Loading();
    },
  );

  Widget _pair(Rate rate, BuildContext buildContext) => Slidable(
    endActionPane: ActionPane(
      motion: const StretchMotion(),
      children: [
        SlidableAction(
          autoClose: true,
          onPressed: (context) => showDialog(
            context: context,
            builder: (context) => DialogWidget(
              message: AppStrings.confirmDelete,
              buttonEntities: [
                ButtonEntity(
                  title: AppStrings.yes,
                  onTap: () => Navigator.of(context).pop(true),
                ),
                ButtonEntity(
                  title: AppStrings.no,
                  onTap: () => Navigator.of(context).pop(false),
                ),
              ])).then((value) => value is bool && value ? BlocProvider.of<RatesBloc>(buildContext).deleteRate(rate) : null),
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          icon: Icons.delete,
        ),
      ]),
    child: Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PairWidget(pair: rate.pair),
          Text(rate.value)
        ])));

  AppBar _appBar(BuildContext context, List<Rate> rates) => AppBar(
    title: const Text(AppStrings.titleScreens),
    actions: [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          BlocProvider.of<PairsBloc>(context).loadPairs(List.generate(rates.length, (index) => rates[index].pair));
          Navigator.of(context).pushNamed(PairsScreen.id);
        }
      )
    ]);
}