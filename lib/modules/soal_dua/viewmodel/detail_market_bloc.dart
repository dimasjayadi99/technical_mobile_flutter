import 'package:bloc/bloc.dart';
import 'package:savoria_test/modules/soal_dua/model/market_model.dart';

import '../../../utils/database_helper.dart';

class DetailMarketInitState {}

class DetailMarketLoadingState extends DetailMarketInitState{}

class DetailMarketSuccessState extends DetailMarketInitState{
  final MarketModel data;
  DetailMarketSuccessState(this.data);
}

class DetailMarketErrorState extends DetailMarketInitState{}

class DetailMarketBloc extends Cubit<DetailMarketInitState>{
  DetailMarketBloc() : super(DetailMarketInitState());

  void getDetailMarket(String marketKode) async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getDetailMarket(marketKode);
    emit(DetailMarketLoadingState());
    try{
      if(data != null){
        emit(DetailMarketSuccessState(data));
      }else{
        emit(DetailMarketErrorState());
      }
    }catch(error){
      emit(DetailMarketErrorState());
    }
  }
}