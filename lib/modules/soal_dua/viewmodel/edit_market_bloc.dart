import 'package:bloc/bloc.dart';
import 'package:savoria_test/modules/soal_dua/model/market_model.dart';
import 'package:savoria_test/utils/database_helper.dart';

abstract class AbsEditMarket{}

class EditMarketEvent extends AbsEditMarket {
  final String marketKode;
  final String marketName;
  final String marketAddress;
  final String latitudeLongitude;
  final String photo;
  final String photoPath;
  final String createdDate;
  final String updatedDate;

  EditMarketEvent({
    required this.marketKode,
    required this.marketName,
    required this.marketAddress,
    required this.latitudeLongitude,
    required this.photo,
    required this.photoPath,
    required this.createdDate,
    required this.updatedDate
  });

}

class EditMarketInitState{}

class EditMarketLoadingState extends EditMarketInitState{}

class EditMarketSuccessState extends EditMarketInitState{}

class EditMarketFailedState extends EditMarketInitState{}

class EditMarketBloc extends Bloc<AbsEditMarket, EditMarketInitState>{
  EditMarketBloc() : super(EditMarketInitState()){
    on<EditMarketEvent>((event,emit) async {
      final dbHelper = DatabaseHelper();
      emit(EditMarketLoadingState());
      try{
        final data = MarketModel(
            marketKode: event.marketKode,
            marketName: event.marketName,
            marketAddress: event.marketAddress,
            latitudeLongitude: event.latitudeLongitude,
            photo: event.photo,
            photoPath: event.photoPath,
            createdDate: event.createdDate,
            updatedDate: event.updatedDate
        );
        await dbHelper.updateMarket(data,event.marketKode);
        emit(EditMarketSuccessState());
      }catch(error){
        return;
      }
    });
  }
}