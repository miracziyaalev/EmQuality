import 'dart:convert';
import 'dart:developer';

import 'package:emkaliteapp/core/constant/url.dart';
import 'package:http/http.dart' as http;

import '../model/operationModel.dart';

class GetOperationsService {
  // ignore: body_might_complete_normally_nullable
  static Future<List<OperationModel>?> fetchOperationsAll() async {
    try {
      var response = await http.get(
        Uri.parse(ConstantApiUrl.baseURL + ConstantApiUrl.getSfdc20T),
        headers: {"content-type": "application/json"},
      );

      if (response.statusCode == 200) {
        var operations = (json.decode(response.body) as List)
            .map((i) => OperationModel.fromJson(i))
            .toList();

        return operations;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load info');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<List<OperationModel>?> fetchChosenOperation(
      {required String chosenWorkNumber}) async {
    try {
      var response = await http.get(
        Uri.parse(ConstantApiUrl.baseURL +
            ConstantApiUrl.getSpesificSfdc20T +
            chosenWorkNumber),
        headers: {"content-type": "application/json"},
      );

      if (response.statusCode == 200) {
        var operations = (json.decode(response.body) as List)
            .map((i) => OperationModel.fromJson(i))
            .toList();

        return operations;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load info');
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
