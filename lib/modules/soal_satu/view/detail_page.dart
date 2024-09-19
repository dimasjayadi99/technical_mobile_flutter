import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savoria_test/api/api_service.dart';
import 'package:savoria_test/modules/soal_satu/model/list_outlet.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.outletId});

  final int outletId;

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  ApiService? apiService;
  Data? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(context);
    fetchDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchDetail() async {
    try {
      final response = await apiService!.fetchOutletById(widget.outletId);
      setState(() {
        data = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF7F6F6),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.blue),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text('Data tidak ditemukan'))
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data!.photo),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data!.outletName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: data!.activeFlag ? Colors.green : Colors.red)),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.pin_drop, size: 16, color: Colors.black.withOpacity(0.5),),
                      const SizedBox(width: 5),
                      Text(data!.areaName, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black.withOpacity(0.5))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Text(data!.outletAddress, style: const TextStyle(fontWeight: FontWeight.normal)),
                  const SizedBox(height: 5),
                  Text("${data!.latitude} : ${data!.longtitude}", style: const TextStyle(fontWeight: FontWeight.normal)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
