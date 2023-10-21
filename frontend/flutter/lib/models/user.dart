// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geocoding/geocoding.dart';

import 'billing_address.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final double latitude;
  final double longitude;
  final List<BillingAddress> billingAddresses; // Add this field

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.latitude,
    required this.longitude,
    required this.billingAddresses, // Initialize this field
  });

  @override
  List<Object> get props => [name, email, phone, userType, id];

  User copyWith(
      {String? name,
      String? email,
      String? phone,
      String? userType,
      String? id,
      double? latitude,
      double? longitude, List<BillingAddress>? billingAddresses,

      }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      billingAddresses: billingAddresses ?? this.billingAddresses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'latitude': latitude,
      'longitude': longitude,
      'billingAddresses': billingAddresses.map((address) => address.toJson()).toList(),
      "_id": id,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] ?? "",
      userType: map['userType'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      id: map['_id'] as String,
      billingAddresses: (map['billingAddresses'] as List<dynamic>)
          .map((json) => BillingAddress.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  Future<String> getLocationName() async {
    try {
      print(latitude);
      print(longitude);
      List<Placemark> placemarks = await placemarkFromCoordinates(this.latitude, this.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return placemark.name ?? '';
      }
      return '';
    } catch (e) {
      print('Error getting location name: $e');
      return '';
    }
  }

  @override
  bool get stringify => true;
}
