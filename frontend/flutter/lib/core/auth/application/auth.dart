import 'dart:convert';

import 'package:agro_millets/data/auth_state_repository.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/models/user.dart';
import "package:agro_millets/secrets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../models/billing_address.dart';


class AuthManager {
  final BuildContext context;
  final WidgetRef ref;
  AuthManager(this.context, this.ref);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<int> loginUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    ref.read(authProvider).clearUserData();
    isLoading.value = true;
    var response = await http.post(
      Uri.parse("$API_URL/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );
    isLoading.value = false;
    Map<String, dynamic> data = json.decode(response.body);

    if (data["statusCode"] == 200) {
      ref.read(authProvider).updateUserData(
        User.fromMap(data["data"]),
      );

      return 1;
    } else {
      showToast(data["message"]);
      return -1;
    }
  }
  Future<int> updateUserData({
    required String? email,
  }) async {
    ref.read(authProvider).clearUserData();
    isLoading.value = true;
    var response = await http.post(
      Uri.parse("$API_URL/auth/get-user-data"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "email": email,
      }),
    );
    isLoading.value = false;
    Map<String, dynamic> data = json.decode(response.body);

    if (data["statusCode"] == 200) {
      ref.read(authProvider).updateUserData(
        User.fromMap(data["data"]),
      );

      return 1;
    } else {
      showToast(data["message"]);
      return -1;
    }
  }

  Future<int> signUpUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String userType,
    required LatLng coordinate,
    required BillingAddress billingAddress, // Add this parameter


  }) async {
    ref.read(authProvider).clearUserData();
    isLoading.value = true;
    var response = await http.post(
      Uri.parse("$API_URL/auth/signup"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
          {
            "name": name,
            "email": email,
            "password": password,
            "latitude":coordinate.latitude,
            "longitude":coordinate.longitude,
            "phone": phone,
            "userType": userType,
            "billingAddresses": [billingAddress.toJson()], // Include billing address
          }
      ),
    );
    isLoading.value = false;
    Map<String, dynamic> data = json.decode(response.body);

    if (data["statusCode"] == 200) {
      ref.read(authProvider).updateUserData(User.fromMap(data["data"]));

      return 1;
    } else {
      showToast(data["message"]);
      return -1;
    }
  }

  Future<User?> searchForUser(String email) async {
    var response = await http.post(
      Uri.parse("$API_URL/auth/exists"),
      body: {"email": email},
    );

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      if (data["statusCode"] == 200) {
        return User.fromMap(data["data"]);
      }
    }
    return null;
  }
}