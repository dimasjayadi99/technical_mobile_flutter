import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:savoria_test/modules/soal_satu/model/list_outlet.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  final String baseUrl = ApiConfig.baseUrl;
  final BuildContext context;

  ApiService(this.context);

  // fetch list outlet
  Future<ListOutLet> fetchList() async {
    String apiUrl = baseUrl;
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Data> listData = (data['data'] as List<dynamic>).map((item) {
        return Data(
          outletId: item['outlet_id'],
          outletName: item['outlet_name'],
          outletAddress: item['outlet_address'],
          areaId: item['area_id'],
          areaName: item['area_name'],
          photo: item['photo'],
          latitude: item['latitude'],
          longtitude: item['longtitude'],
          createdAt: item['created_at'],
          createdBy: item['created_by'],
          activeFlag: item['active_flag'],
        );
      }).toList();

      return ListOutLet(
        status: data['status'],
        message: data['messages'],
        data: listData,
      );
    } else {
      throw Exception('Failed to load data. Status Code: ${response.statusCode}');
    }
  }


  // Fetch outlet by ID
  Future<Data?> fetchOutletById(int id) async {
    try {
      final listOutLet = await fetchList();
      return listOutLet.data.firstWhere((outlet) => outlet.outletId == id);
    } catch (e) {
      return null;
    }
  }
}
