import 'package:agro_millets/data/auth_state_repository.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/user.dart';

final mapProvider =
ChangeNotifierProvider<MapProvider>((ref) => MapProvider());

class MapProvider extends ChangeNotifier {
  List<User> _map = [];
  List<CartItem> _cart = [];

  addItemToMap(User item) {
    _map = [..._map, item];
    appCache.updateAppCache(AppState(
      cart:_cart,
      map: [item, ...?appState.value.map],
      user: appState.value.user,
      isLoggedIn: appState.value.isLoggedIn,
    ));
    notifyListeners();
  }

  setMap(List<User> list) {
    _map = list;
    appCache.updateAppCache(AppState(
      map: list,
      user: appState.value.user,
      isLoggedIn: appState.value.isLoggedIn, cart: [],
    ));

    notifyListeners();
  }

  List<User> getMap() => [..._map];
}
