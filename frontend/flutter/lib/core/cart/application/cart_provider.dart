import 'package:agro_millets/data/auth_state_repository.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider =
    ChangeNotifierProvider<CartProvider>((ref) => CartProvider());

class CartProvider extends ChangeNotifier {
  List<CartItem> _cart = [];

  addItemToCart(CartItem item) {
    _cart = [..._cart, item];
    appCache.updateAppCache(AppState(
      cart: [CartItem(count: 1, item: item.item), ...appState.value.cart],
      user: appState.value.user,
      isLoggedIn: appState.value.isLoggedIn, map: [],
    ));
    notifyListeners();
  }

  removeItemFromCart(String itemId) {
    var cart = appState.value.cart;
    cart.removeWhere((element) => element.item == itemId);

    setCart(cart);
  }

  setCart(List<CartItem> list) {
    _cart = list;
    appCache.updateAppCache(AppState(
      cart: list,
      user: appState.value.user,
      isLoggedIn: appState.value.isLoggedIn, map: [],
    ));

    notifyListeners();
  }

  List<CartItem> getCart() => [..._cart];

  // Increment the count of a cart item
  incrementItemCount(String itemId) {
    final index = _cart.indexWhere((item) => item.item == itemId);
    if (index != -1) {
      _cart[index] = _cart[index].copyWith(count: _cart[index].count + 1);
      // _updateAppCache();
      notifyListeners();
    }
  }

  // Decrement the count of a cart item
  decrementItemCount(String itemId) {
    final index = _cart.indexWhere((item) => item.item == itemId);
    if (index != -1 && _cart[index].count > 1) {
      _cart[index] = _cart[index].copyWith(count: _cart[index].count - 1);
      // _updateAppCache();
      notifyListeners();
    }
  }
}

addCartToBackend() {}
fetchCartFromBackend() {}
