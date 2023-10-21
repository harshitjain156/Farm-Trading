class BillingAddress {
  final String province;
  final String city;
  final String areaName;
  final String fullName;
  final String email;
  final String postalCode;
  final String phone;
  final String category;
  final bool isDefaultBilling;
  final bool isDefaultShipping;

  BillingAddress({
    this.province = '',
    this.city = '',
    this.areaName = '',
    this.fullName = '',
    this.email = '',
    this.postalCode = '',
    this.phone = '',
    this.category = '',
    this.isDefaultBilling = false,
    this.isDefaultShipping = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
      'areaName': areaName,
      'fullName': fullName,
      'email': email,
      'postalCode': postalCode,
      'phone': phone,
      'category': category,
      'isDefaultBilling': isDefaultBilling,
      'isDefaultShipping': isDefaultShipping,
    };
  }

  factory BillingAddress.fromJson(Map<String, dynamic> json) {
    return BillingAddress(
      province: json['province'] as String? ?? '',
      city: json['city'] as String? ?? '',
      areaName: json['areaName'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      category: json['category'] as String? ?? '',
      isDefaultBilling: json['isDefaultBilling'] as bool? ?? false,
      isDefaultShipping: json['isDefaultBilling'] as bool? ?? false,
    );
  }
}
