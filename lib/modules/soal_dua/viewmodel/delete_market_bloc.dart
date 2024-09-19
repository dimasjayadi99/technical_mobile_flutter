import 'package:bloc/bloc.dart';
import 'package:savoria_test/utils/database_helper.dart';

abstract class AbsDeleteMarket{}

class DeleteMarketEvent extends AbsDeleteMarket {
  final String marketKode;

  DeleteMarketEvent({
    required this.marketKode,
  });
}

class DeleteMarketInitState{}

class DeleteMarketLoadingState extends DeleteMarketInitState{}

class DeleteMarketSuccessState extends DeleteMarketInitState{}

class DeleteMarketFailedState extends DeleteMarketInitState{}

class DeleteMarketBloc extends Bloc<AbsDeleteMarket, DeleteMarketInitState>{
  DeleteMarketBloc() : super(DeleteMarketInitState()){
    on<DeleteMarketEvent>((event,emit) async {
      final db = DatabaseHelper();
      try{
        var delete = await db.deleteMarket(event.marketKode);
        if(delete){
          emit(DeleteMarketSuccessState());
        }else{
          emit(DeleteMarketFailedState());
        }
      }catch(error){
        return;
      }
    });
  }
}