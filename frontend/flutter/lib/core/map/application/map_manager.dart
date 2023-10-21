import 'dart:async';
import 'dart:convert';

import 'package:agro_millets/core/map/application/map_provider.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/cart_item.dart';
import "package:agro_millets/secrets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../models/user.dart';

class MapManager {
  final BuildContext context;
  Timer? timer;
  final WidgetRef ref;

  MapManager(this.context, this.ref, {bool poll = true}) {
    if (poll) {
      attach();
    }
  }

  dispose() {
    debugPrint("[map_manager] Detaching Listeners...");
    if (timer != null) {
      timer!.cancel();
    }
  }

  // Using Polling instead of WebSockets
  attach() async {
    debugPrint("[map_manager] Attaching Listeners...");
    var data = await getMap();
    ref.read(mapProvider).setMap(data);

    timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        if (context.mounted) {
          var data = await getMap();
          ref.read(mapProvider).setMap(data);
        }
      },
    );
  }

  Future<List<User>> getMap() async {
    if (appState.value.user == null) return [];
    var response = await http.get(
      Uri.parse("$API_URL/auth/farmer-coordinates/getAll"),
    );

    Map data = json.decode(response.body);
    if (data["statusCode"] == 200) {
      List dataMap = data["data"];
      List<User> list = [];

      for (var e in dataMap) {
        list.add(User.fromMap(e));
        // list.add(LatLng(e['latitude'],e['longitude']));
      }
      return list;
    }
    return [];
  }

}
