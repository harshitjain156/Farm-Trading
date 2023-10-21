import 'dart:async';
import 'dart:convert';

import 'package:agro_millets/core/home/application/home_provider.dart';
import 'package:agro_millets/core/home/presentation/news/constants.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/millet_item.dart';
import "package:agro_millets/secrets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../models/order_item.dart';
import '../../../models/user.dart';

class HomeManager {
  final BuildContext context;
  Timer? timer;
  final WidgetRef ref;

  HomeManager(this.context, this.ref) {
    attach();
  }

  dispose() {
    debugPrint("[home_manager] Detaching Listeners...");
    if (timer != null) {
      timer!.cancel();
    }
  }

  // Using Polling instead of WebSockets
  attach() async {
    debugPrint("[home_manager] Attaching Listeners...");
    var data = await getAllItems();
    ref.read(homeProvider).updateItems(data);
    if (appCache.isFarmer()) {
      var deliveryData = await getAllDeliveries(appState.value.user!);
      ref.read(homeProvider).updateItemDeliveries(deliveryData);
    } else {
      var orderData = await getAllOrders(appState.value.user!);
      ref.read(homeProvider).updateItemOrder(orderData);
    }

    timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        if (context.mounted) {
          var data = await getAllItems();
          ref.read(homeProvider).updateItems(data);
          if (appCache.isFarmer()) {
            var deliveryData = await getAllDeliveries(appState.value.user!);
            ref.read(homeProvider).updateItemDeliveries(deliveryData);
          } else {
            var orderData = await getAllOrders(appState.value.user!);
            ref.read(homeProvider).updateItemOrder(orderData);
          }
        }
      },
    );
  }

  attachCategory(String category) async {
    debugPrint("[home_manager] Attaching Listeners...");
    var data = await getCategoryItems(category);
    ref.read(homeProvider).updateItems(data);

    timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        if (context.mounted) {
          var data = await getCategoryAll(category);
          ref.read(homeProvider).updateItems(data);
        }
      },
    );
  }

  attachOrder(User? user) async {
    debugPrint("[home_manager] Attaching Listeners...");
    var data = await getAllOrders(user!);
    ref.read(homeProvider).updateItemOrder(data);

    timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        if (context.mounted) {
          var data = await getAllOrders(user);
          ref.read(homeProvider).updateItemOrder(data);
        }
      },
    );
  }

  // attachDeliveries(User? user) async {
  //   debugPrint("[home_manager] Attaching Listeners...");
  //   var data = await getAllDeliveries(user!);
  //   ref.read(homeProvider).updateItemDeliveries(data);
  //
  //   timer = Timer.periodic(
  //     const Duration(seconds: 10),
  //     (timer) async {
  //       if (context.mounted) {
  //         var data = await getAllDeliveries(user);
  //         ref.read(homeProvider).updateItemDeliveries(data);
  //       }
  //     },
  //   );
  // }

  Future<List<MilletItem>> getAllItems() async {
    if (appCache.isFarmer()) {
      return await getAllFarmerItems(appState.value.user!.id);
    }
    return getAll();
  }

  Future<List<MilletItem>> getAllRecommendedItems(MilletItem item) async {
    if (appCache.isFarmer()) {
      return await getAllRecommendedItems(item);
    }
    return getAll();
  }

  Future<List<MilletItem>> getCategoryItems(String category) async {
    if (appCache.isFarmer()) {
      return await getAllFarmerCategoryItems(appState.value.user!.id, category);
    }
    return getCategoryAll(category);
  }

  // Future<List<MilletItem>> getAllCategories() async {
  //   List<MilletItem> list = ['vegetables','fruits','grains','dairy products'];
  //   return list;
  // }

  Future<List<MilletItem>> getAll() async {
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

  Future<List<MilletItem>> getCategoryAll(String category) async {
    var response = await http.get(
      Uri.parse("$API_URL/list/getAll/$category"),
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
}

Future<List<MilletItem>> getAllFarmerItems(String id) async {
  var response = await http.get(
    Uri.parse("$API_URL/list/getAll/$id"),
  );

  debugPrint(response.request!.url.toString());
  Map data = json.decode(response.body);

  if (data["statusCode"] == 200) {
    List dataMap = data["data"];
    List<MilletItem> list = [];

    for (var e in dataMap) {
      list.add(MilletItem.fromMap(e));
    }
    // debugPrint("Farmer Items $list");

    return list;
  }
  return [];
}

Future<List<MilletItem>> getAllRecommendedItems(MilletItem item) async {
  var response = await http.post(
    Uri.parse("$API_URL/list/getRecommendations"),
    body: {"itemName": item.name},
  );

  debugPrint(response.request!.url.toString());
  Map data = json.decode(response.body);

  if (data["statusCode"] == 200) {
    List dataMap = data["data"];
    List<MilletItem> list = [];

    for (var e in dataMap) {
      list.add(MilletItem.fromMap(e));
    }
    //debugPrint("Recommended Items $list");

    return list;
  }
  return [];
}

Future<List<MilletItem>> getAllFarmerCategoryItems(
    String id, String category) async {
  var response = await http.get(
    Uri.parse("$API_URL/list/getAll/$category/$id"),
  );

  debugPrint(response.request!.url.toString());
  Map data = json.decode(response.body);

  if (data["statusCode"] == 200) {
    List dataMap = data["data"];
    List<MilletItem> list = [];

    for (var e in dataMap) {
      list.add(MilletItem.fromMap(e));
    }
    // debugPrint("Farmer Items $list");

    return list;
  }
  return [];
}

Future<List<MilletOrder>> getAllOrders(User? user) async {
  var response = await http.get(
    Uri.parse("$API_URL/list/getAllOrder/${appState.value.user!.id}"),
    // body: {"wholesalerID": user.id},
  );

  debugPrint(response.request!.url.toString());
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

Future<List<MilletOrder>> getAllDeliveries(User? user) async {
  var response = await http.get(
    Uri.parse("$API_URL/list/getAllDeliveries/${appState.value.user!.id}"),
    // body: {"wholesalerID": user.id},
  );

  debugPrint(response.request!.url.toString());
  Map data = json.decode(response.body);

  if (data["statusCode"] == 200) {
    List dataMap = data["data"];
    List<MilletOrder> list = [];

    for (var e in dataMap) {
      list.add(MilletOrder.fromMap(e));
    }
    // debugPrint("Wholesaler Orders $list");

    return list;
  }
  return [];
}

Future<void> addItem({
  required String name,
  required String listedBy,
  String? farmer,
  required String description,
  required String category,
  required List<String> images,
  required double quantity,
  required String quantityType,
  required double price,
}) async {
  var response = await http.post(
    Uri.parse("$API_URL/list/addItem"),
    headers: {"content-type": "application/json"},
    body: json.encode(
      {
        "listedBy": listedBy,
        "farmer": farmer,
        "name": name,
        "category": category,
        "description": description,
        "images": images,
        "quantityType": quantityType,
        "quantity": quantity,
        "price": price,
        "comments": [],
      },
    ),
  );
  showToast("Your item has been added");
}

Future<MilletOrder?> addItemOrder({
  required String listedBy,
  required bool isPaid,
  required String farmerId,
  required int quantity,
  required String quantityType,
  required String phoneCustomer,
  required String phoneFarmer,
  required double price,
  required String item,
  required String status,
  required String modeOfPayment,
}) async {
  var response = await http.post(
    Uri.parse("$API_URL/list/addOrder"),
    headers: {"content-type": "application/json"},
    body: json.encode(
      {
        "listedBy": listedBy,
        "isPaid": isPaid,
        "farmerId": farmerId,
        "phoneCustomer": phoneCustomer,
        "phoneFarmer": phoneFarmer,
        "quantityType": quantityType,
        "quantity": quantity,
        "price": price,
        "item": item,
        "status": status,
        "modeOfPayment": modeOfPayment,
      },
    ),
  );
  Map data = json.decode(response.body);
  if (data["statusCode"] == 200) {
    MilletOrder item = MilletOrder.fromMap(data["data"]);
    return item;
  }
  showToast("Your order has been added");
  return null;
}

Future<MilletItem?> getItemById(String id) async {
  var response = await http.get(Uri.parse("$API_URL/list/getItem/$id"));
  Map data = json.decode(response.body);

  if (data["statusCode"] == 200) {
    MilletItem item = MilletItem.fromMap(data["data"]);
    return item;
  }
  return null;
}

Future<void> deleteItem(String id) async {
  if (!appState.value.isLoggedIn || appState.value.user == null) {
    showToast("You need to login to perform this action");
    return;
  }

  var response = await http.post(
    Uri.parse("$API_URL/admin/deleteItem"),
    headers: {"content-type": "application/json"},
    body: json.encode(
      {"itemId": id, "adminId": appState.value.user!.id},
    ),
  );

  //print(response.body.toString());
  var data = json.decode(response.body);
  showToast(data["message"]);
}

Future<void> updateOrderStatus(String id, String status) async {
  if (!appState.value.isLoggedIn || appState.value.user == null) {
    showToast("You need to login to perform this action");
    return;
  }

  var response = await http.post(
    Uri.parse("$API_URL/list/updateOrderStatus"),
    headers: {"content-type": "application/json"},
    body: json.encode(
      {"orderId": id, "newStatus": status},
    ),
  );

  //print(response.body.toString());
  var data = json.decode(response.body);
  print('----data---');
  print(data);
  if (data["statusCode"] == 200) {
    showSuccessToast("Status Updated to ${status} !");

  } else {
    showFailureToast("Status Couldn't be updated !");
  }
}
