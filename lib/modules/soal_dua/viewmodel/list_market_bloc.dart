import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:savoria_test/modules/soal_dua/model/market_model.dart';
import '../../../utils/database_helper.dart';

class ListMarketInitState {}

class ListMarketLoadingState extends ListMarketInitState{}

class ListMarketSuccessState extends ListMarketInitState{
  final List<MarketModel> listData;
  ListMarketSuccessState(this.listData);
}

class ListMarketEmptyState extends ListMarketInitState{}

class ListMarketBloc extends Cubit<ListMarketInitState>{
  ListMarketBloc() : super(ListMarketInitState());

  void getListMarket() async {
    final dbHelper = DatabaseHelper();
    final listData = await dbHelper.getListMarket();
    emit(ListMarketLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    try{
      if(listData.isNotEmpty){
        emit(ListMarketSuccessState(listData));
      }else{
        emit(ListMarketEmptyState());
      }
    }catch(error){
      debugPrint("Error Message : $error");
    }
  }
}