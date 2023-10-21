import 'dart:convert';

import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/models/millet_item.dart';
import 'package:agro_millets/models/user.dart';
import 'package:agro_millets/secrets.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../models/order_item.dart';

class AdminAPIs {
  // http://localhost:3000/api/auth/getAll

  static Future<List<User>> getAllUsers() async {
    List<User> listOfUsers = [];
    String userId = appState.value.user!.id;
    var response = await http.post(
      Uri.parse("$API_URL/auth/getAll"),
      body: {"adminId": userId},
    );

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      if (data["statusCode"] == 200) {
        List list = data["data"] as List;
        for (var e in list) {
          listOfUsers.add(User.fromMap(e));
        }
      }
    }
    return listOfUsers;
  }

  static Future<List<MilletItem>> getAllItems() async {
    var response = await http.get(
      Uri.parse("$API_URL/list/getAll"),
    );

    Map data = json.decode(response.body);
    if (data["statusCode"] == 200) {
      List dataMap = data["data"];
      List<MilletItem> list = [];

      for (var e in dataMap) {
        list.add(MilletItem.fromMap(e));
      }
      return list;
    }
    return [];
  }

  static Future<List<MilletItem>> getAllRecommendedItems(MilletItem item) async {

    var response = await http.post(
      Uri.parse("$API_URL/list/getRecommendations"),
      body: {"itemID": item.id},
    );

    Map data = json.decode(response.body);
    if (data["statusCode"] == 200) {
      List dataMap = data["data"];
      List<MilletItem> list = [];

      for (var e in dataMap) {
        list.add(MilletItem.fromMap(e));
      }
      return list;
    }
    return [];
  }
  static Future<List<MilletItem>> getAllOrderRecommendedItems(MilletItem item) async {

    var response = await http.get(
      Uri.parse("$API_URL/list/getOrderRecommendations/${item.id}"),
    );

    Map data = json.decode(response.body);
    if (data["statusCode"] == 200) {
      List dataMap = data["data"];
      List<MilletItem> list = [];

      for (var e in dataMap) {
        list.add(MilletItem.fromMap(e));
      }
      return list;
    }
    return [];
  }

  static Future<List<LatLng>> getAllFarmerCoordinates() async {
    var response = await http.get(
      Uri.parse("$API_URL/farmer-coordinates/getAll"),
    );

    Map data = json.decode(response.body);
    if (data["statusCode"] == 200) {
      List dataMap = data["data"];
      List<LatLng> list = [];

      for (var e in dataMap) {
        list.add(LatLng(e.lattitude, e.longitude));
      }
      return list;
    }
    return [];
  }

  static Future<List<MilletItem>> getRecentItems() async {
    var response = await http.get(
      Uri.parse("$API_URL/list/getRecent"),
    );

    Map data = json.decode(response.body);
    if (data["statusCode"] == 200) {
      List dataMap = data["data"];
      List<MilletItem> list = [];

      for (var e in dataMap) {
        list.add(MilletItem.fromMap(e));
      }
      return list;
    }
    return [];
  }

  // orders
  static Future<List<MilletOrder>> getAllOrders(User user) async {
    // var response = await http.get(
    //   Uri.parse("$API_URL/list/getAllOrder"),
    // );
    var response = await http.post(
      Uri.parse("$API_URL/list/getAllOrder"),
      body: {"wholesalerID": user.id},
    );
    Map data = json.decode(response.body);
    if (data["statusCode"] == 200) {
      List dataMap = data["data"];
      List<MilletOrder> list = [];

      for (var e in dataMap) {
        list.add(MilletOrder.fromMap(e));
      }
      return list;
    }
    return [];
  }

}
