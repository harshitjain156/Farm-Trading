// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MilletOrder {
  final String id;
  final String listedBy;
  final bool isPaid;
  final String farmerId;
  final String phoneFarmer;
  final String phoneCustomer;
  final String status;
  final double price;
  final double quantity;
  final String quantityType;
  final DateTime listedAt;
  final String item;
  final String modeOfPayment;

  MilletOrder({
    required this.id,
    required this.listedBy,
    required this.isPaid,
    required this.farmerId,
    required this.price,
    required this.phoneFarmer,
    required this.phoneCustomer,
    required this.quantity,
    required this.quantityType,
    required this.listedAt,
    required this.item,
    required this.status,
    required this.modeOfPayment,
  });


  MilletOrder copyWith({
    String? id,
    String? listedBy,
    bool? isPaid,
    String? farmerId,
    String? phoneFarmer,
    String? phoneCustomer,
    double? price,
    double? quantity,
    String? quantityType,
    String? status,
    DateTime? listedAt,
    String? item,
    String? modeOfPayment,
  }) {
    return MilletOrder(
      id: id ?? this.id,
      listedBy: listedBy ?? this.listedBy,
      isPaid: isPaid ?? this.isPaid,
      farmerId: farmerId ?? this.farmerId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      quantityType: quantityType ?? this.quantityType,
      status: status ?? this.status,
      listedAt: listedAt ?? this.listedAt,
      phoneFarmer:phoneFarmer ?? this.phoneFarmer,
      phoneCustomer:phoneFarmer ?? this.phoneCustomer,
      item: item ?? this.item,
      modeOfPayment: modeOfPayment ?? this.modeOfPayment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'listedBy': listedBy,
      'isPaid': isPaid,
      'farmerId': farmerId,
      'phoneFarmer':phoneFarmer,
      'phoneCustomer':phoneCustomer,
      'price': price,
      'quantity': quantity,
      'status': status,
      'quantityType': quantityType,
      'listedAt': listedAt.toIso8601String(),
      'modeOfPayment': modeOfPayment,
      'item': item,
    };
  }

  factory MilletOrder.fromMap(Map<String, dynamic> map) {
    return MilletOrder(
      id: map['_id'] as String,
      isPaid:map['isPaid'] as bool,
      listedBy: map['listedBy'] as String,
      farmerId: map['farmerId']  as String,
      price: map['price'] * 1.0,
      quantity: map['quantity'] * 1.0,
      status: map['status'] as String,
      quantityType: map['quantityType'],
      listedAt: DateTime.parse(map['listedAt']),
      modeOfPayment: map['modeOfPayment'] as String,
      item: map['item'], phoneFarmer: map['phoneFarmer'], phoneCustomer: map['phoneCustomer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MilletOrder.fromJson(String source) =>
      MilletOrder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MilletItemOrder(id: $id, listedBy: $listedBy,isPaid:$isPaid,farmerId:$farmerId, price: $price,quantity:$quantity,status:$status, listedAt: $listedAt, item: $item)';
  }

  @override
  bool operator ==(covariant MilletOrder other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.listedBy == listedBy &&
        other.isPaid == isPaid &&
        other.farmerId == farmerId &&
        other.price == price &&
        other.quantity == quantity &&
        other.quantityType == quantityType &&
        other.item == item &&
        other.listedAt == listedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    listedBy.hashCode ^
    isPaid.hashCode ^
    farmerId.hashCode ^
    price.hashCode ^
    quantity.hashCode ^
    quantityType.hashCode ^
    item.hashCode ^
    listedAt.hashCode;
  }
}