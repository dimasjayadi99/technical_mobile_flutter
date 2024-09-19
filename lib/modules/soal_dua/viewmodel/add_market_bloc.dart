import 'package:bloc/bloc.dart';
import 'package:savoria_test/modules/soal_dua/model/market_model.dart';
import 'package:savoria_test/utils/database_helper.dart';

abstract class AbsAddMarket{}

class AddMarketEvent extends AbsAddMarket {
  final String marketName;
  final String marketAddress;
  final String latitudeLongitude;
  final String photo;
  final String photoPath;
  final String createdDate;
  final String updatedDate;

  AddMarketEvent({
    required this.marketName,
    required this.marketAddress,
    required this.latitudeLongitude,
    required this.photo,
    required this.photoPath,
    required this.createdDate,
    required this.updatedDate
  });

}

class AddMarketInitState{}

class AddMarketLoadingState extends AddMarketInitState{}

class AddMarketSuccessState extends AddMarketInitState{}

class AddMarketFailedState extends AddMarketInitState{}

class AddMarketBloc extends Bloc<AbsAddMarket, AddMarketInitState>{
  AddMarketBloc() : super(AddMarketInitState()){
    on<AddMarketEvent>((event,emit) async {
      final dbHelper = DatabaseHelper();
      emit(AddMarketLoadingState());
      try{
        final data = MarketModel(
            marketName: event.marketName,
            marketAddress: event.marketAddress,
            latitudeLongitude: event.latitudeLongitude,
            photo: event.photo,
            photoPath: event.photoPath,
            createdDate: event.createdDate,
            updatedDate: event.updatedDate
        );
        await dbHelper.insertMarket(data);
        emit(AddMarketSuccessState());
      }catch(error){
        return;
      }
    });
  }
}