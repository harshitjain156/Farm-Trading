// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:agro_millets/models/cart_item.dart';
import 'package:agro_millets/models/user.dart';
import 'package:latlong2/latlong.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

class AuthProvider extends ChangeNotifier {
  AppState _authState = AppState.initial();

  User? getCurrentUser() => _authState.user;
  bool isLoggedIn() => _authState.isLoggedIn;

  bool isAdmin() {
    return _authState.user == null
        ? false
        : _authState.user!.userType == "admin";
  }

  bool isFarmer() {
    return _authState.user == null
        ? false
        : _authState.user!.userType == "farmer";
  }

  updateUserData(User user) {
    _authState = AppState(
      isLoggedIn: true,
      user: user,
      cart: [], map: [],
    );
    appCache.updateAppCache(_authState);
    notifyListeners();
  }

  clearUserData() {
    appCache.clearAppCache();
    notifyListeners();
  }
}

/*  
@AppState: Stores App State and Credentials.
**/
class AppState {
  final bool isLoggedIn;
  final User? user;

  /// Cart is saved locally on device also 
  final List<CartItem> cart;

  /// Cart is saved locally on device also
  final List<User?>? map;

  const AppState({
    this.isLoggedIn = false,
    required this.user,
    required this.cart,
     this.map,
  });

  factory AppState.initial() {
    return const AppState(
      user: null,
      isLoggedIn: false,
      cart: [],
      map: [],
    );
  }

  AppState copyWith({
    bool? isLoggedIn,
    User? user,
    List<CartItem>? cart,
    List<User>? map,
  }) {
    return AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      cart: cart ?? this.cart,
      map: map ?? this.map,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isLoggedIn': isLoggedIn,
      'user': user?.toMap(),
      'cart': cart.map((x) => x.toMap()).toList(),
      'map': map?.map((x)=>x).toList(),
    };
  }

  factory AppState.fromMap(Map<String, dynamic> map) {
    return AppState(
      isLoggedIn: map['isLoggedIn'] as bool,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      cart: List<CartItem>.from(
        (map['cart']).map<CartItem>(
          (x) => CartItem.fromMap(x as Map<String, dynamic>),
        ),
      ), map: List<User?>.from(
        (map['map']).map((item) {
          if (item.runtimeType == User) {
          return item ;
          }

        }).toList()
    )
    );
  }

  String toJson() => json.encode(toMap());

  factory AppState.fromJson(String source) =>
      AppState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AppState(isLoggedIn: $isLoggedIn, user: $user, cart: $cart)';

  @override
  bool operator ==(covariant AppState other) {
    if (identical(this, other)) return true;

    return other.isLoggedIn == isLoggedIn &&
        other.user == user &&
        listEquals(other.cart, cart);
  }

  @override
  int get hashCode => isLoggedIn.hashCode ^ user.hashCode ^ cart.hashCode;
}
