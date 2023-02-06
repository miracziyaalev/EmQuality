import 'dart:convert';
import 'dart:developer';

import 'package:emkaliteapp/core/constant/url.dart';
import 'package:http/http.dart' as http;

import '../model/machineModel.dart';

class GetMachineStateService {
  // ignore: body_might_complete_normally_nullable
  static Future<List<GetMachineStateModel>?> fetchMachineStatesInfo() async {
    try {
      var response = await http.get(
        Uri.parse(ConstantApiUrl.baseURL + ConstantApiUrl.GetAllTezgahStatus),
        headers: {"content-type": "application/json"},
      );

      if (response.statusCode == 200) {
        var machineStates = (json.decode(response.body) as List)
            .map((i) => GetMachineStateModel.fromJson(i))
            .toList();
        return machineStates;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load info');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
