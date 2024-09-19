import 'package:flutter/material.dart';
import 'package:savoria_test/api/api_service.dart';
import '../../../widget/card_outlet.dart';
import '../model/list_outlet.dart';
import 'detail_page.dart';

class SoalSatu extends StatefulWidget {
  const SoalSatu({super.key});

  @override
  SoalSatuState createState() => SoalSatuState();
}

class SoalSatuState extends State<SoalSatu> {
  ApiService? apiService;
  List<Data>? listData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(context);
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await apiService?.fetchList();
    if (response!.data.isNotEmpty) {
      setState(() {
        listData = response.data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE9E9EB),
      appBar: AppBar(
        title: const Text("List Outlet")
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : listData == []
              ? const Center(child: Text('Tidak ada data'))
              :  ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(outletId: listData![index].outletId)));
                  },
                  child: CardOutlet(listData: listData![index]));
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: listData!.length,
          ),
        ),
      ),
    );
  }
}