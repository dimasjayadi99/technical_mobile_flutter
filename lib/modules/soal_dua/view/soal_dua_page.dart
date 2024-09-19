import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savoria_test/modules/soal_dua/model/market_model.dart';
import 'package:savoria_test/modules/soal_dua/view/editor_market_page.dart';
import 'package:savoria_test/modules/soal_dua/viewmodel/list_market_bloc.dart';
import 'package:savoria_test/widget/card_market.dart';
import 'package:savoria_test/widget/shimmer_widget.dart';

class SoalDua extends StatefulWidget{
  const SoalDua({super.key});

  @override
  SoalDuaState createState() => SoalDuaState();

}

class SoalDuaState extends State<SoalDua>{

  ListMarketBloc? listMarketBloc;
  List<MarketModel> listData = [];

  @override
  void initState() {
    listMarketBloc = ListMarketBloc();
    super.initState();
  }

  @override
  void dispose() {
    listMarketBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => listMarketBloc!..getListMarket(),
      child: Scaffold(
        backgroundColor: const Color(0XFFE9E9EB),
        appBar: AppBar(
            title: const Text("List Market")
        ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.redAccent,
              child: const Icon(Icons.add, color: Colors.white,),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditorMarketPage())).then((onValue) => setState(() {
                  listMarketBloc!.getListMarket();
                }));
              }
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<ListMarketBloc, ListMarketInitState>(
                buildWhen: (context, state) => state is ListMarketLoadingState || state is ListMarketSuccessState || state is ListMarketEmptyState,
                builder: (context,state){
                  if(state is ListMarketLoadingState){
                    return const ShimmerWidget();
                  }
                  else if(state is ListMarketEmptyState){
                    return Center(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_rounded, color: Colors.black.withOpacity(0.5),),
                        const SizedBox(height: 5),
                        const Text("Tidak ada data"),
                      ],
                    ));
                  }else if(state is ListMarketSuccessState){
                    listData = state.listData;
                    return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditorMarketPage(marketKode: listData[index].marketKode,))).then((onValue) => setState(() {
                              listMarketBloc!.getListMarket();
                            }));
                          },
                          child: CardMarket(marketModel: listData[index]),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: listData.length,
                    );
                  }else{
                    return Container();
                  }
                },
              ),
            )
        )
      ),
    );
  }

}