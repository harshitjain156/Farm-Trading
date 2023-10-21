import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../data/cache/app_cache.dart';
import '../../../models/billing_address.dart';
import '../../../secrets.dart';
import '../../auth/application/auth.dart';

class AddAddressForm extends ConsumerStatefulWidget {
  final BillingAddress billingAddress;

  final String category;

  AddAddressForm({required this.billingAddress, required this.category});

  @override
  ConsumerState<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends ConsumerState<AddAddressForm> {
  late AuthManager _authManager;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController areaNameController = TextEditingController();
  int billingItemIndex = 0;
  late String selectedProvince;
  bool isDefaultAddress = false;
  bool isDefaultBillingAddress = false;

  List<String> provinces = [
    'Province 1',
    'Province 2',
    'Bagmati',
    'Gandaki',
    'Lumbini',
    'Karnali',
    'Sudurpaschim',
  ];

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Future<void> updateBillingAddress({
    required String fullName,
    required String email,
    required String city,
    required String province,
    required String phone,
    required String postalCode,
    required String areaName,
    required String category,
    required bool isDefaultBilling,
    required bool isDefaultShipping,
  }) async {
    print('---requesting---');
    if (this.widget.category == 'shipping') {
      billingItemIndex = 1;
    } else {
      billingItemIndex = 0;
    }
    final response = await http
        .put(
      Uri.parse(
          "$API_URL/auth/update-billing-address/${appState.value.user?.id}/${billingItemIndex}"),
      headers: {"content-type": "application/json"},
      body: json.encode(
        {
          "fullName": fullName,
          "email": email,
          "phone": phone,
          "city": city,
          "province": province,
          "postalCode": postalCode,
          "areaName": areaName,
          "category": this.widget.category,
          "isDefaultBilling": isDefaultBilling,
          "isDefaultShipping": isDefaultShipping,
        },
      ),
    )
        .then((value) async {
      await _authManager.updateUserData(
        email: appState.value.user?.email.trim(),
      );
      Navigator.of(context).pop(true);
    });
  }

  @override
  void initState() {
    _authManager = AuthManager(context, ref);
    super.initState();

    fullNameController.text = widget.billingAddress.fullName;
    emailController.text = widget.billingAddress.email;
    phoneController.text = widget.billingAddress.phone;
    cityController.text = widget.billingAddress.city;
    postalCodeController.text = widget.billingAddress.postalCode;
    areaNameController.text = widget.billingAddress.areaName;
    selectedProvince = widget.billingAddress.province;
    isDefaultAddress = widget.billingAddress.isDefaultShipping;
    isDefaultBillingAddress = widget.billingAddress.isDefaultBilling;
  }

  @override
  Widget build(BuildContext context) {
    Widget finishButton = InkWell(
      onTap: () async {
        updateBillingAddress(
            fullName: fullNameController.text,
            email: emailController.text,
            phone: phoneController.text,
            city: cityController.text,
            province: selectedProvince,
            postalCode: postalCodeController.text,
            areaName: areaNameController.text,
            category: this.widget.category,
            isDefaultBilling: isDefaultAddress,
            isDefaultShipping: isDefaultBillingAddress);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          color: Colors.green,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ],
          borderRadius: BorderRadius.circular(9.0),
        ),
        child: Center(
          child: Text(
            "Finish",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          TextFormField(
            controller: fullNameController,
            decoration: _inputDecoration('Full Name'),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            decoration: _inputDecoration('Email'),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            decoration: _inputDecoration('Mobile Number'),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: cityController,
            decoration: _inputDecoration('City'),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: areaNameController,
            decoration: _inputDecoration('Area Name'),
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedProvince != null ? selectedProvince : 'Province 1',
            decoration: _inputDecoration('Province'),
            items: provinces.map((province) {
              return DropdownMenuItem<String>(
                value: province,
                child: Text(province),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProvince = newValue!;
                print('----');
                print(selectedProvince);
              });
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: postalCodeController,
            decoration: _inputDecoration('Postal Code'),
            keyboardType: TextInputType.number,
          ),
          // SizedBox(height: 13),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(8.0),
          //   ),
          //   child: Column(
          //     children: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Text(
          //           'Default Address Options',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18,
          //           ),
          //         ),
          //       ),
          //       ClipRect(
          //         child: Container(
          //           padding: EdgeInsets.all(16.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: <Widget>[
          //               Row(
          //                 children: <Widget>[
          //                   Checkbox(
          //                     value: widget.billingAddress.isDefaultShipping,
          //                     onChanged: (newValue) {
          //                       setState(() {
          //                         isDefaultAddress = newValue!;
          //                       });
          //                     },
          //                   ),
          //                   Text('Default Shipping Address'),
          //                 ],
          //               ),
          //               if (this.widget.category != 'shipping')
          //                 Row(
          //                   children: <Widget>[
          //                     Checkbox(
          //                       value: widget.billingAddress.isDefaultBilling,
          //                       onChanged: (newValue) {
          //                         setState(() {
          //                           isDefaultBillingAddress = newValue!;
          //                         });
          //                       },
          //                     ),
          //                     Text('Default Billing Address'),
          //                   ],
          //                 ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 10), // Add a small space
          Center(child: finishButton),
          // ElevatedButton(
          //   onPressed: () {
          //     updateBillingAddress();
          //   },
          //   child: Text('Update Address'),
          // ),
        ],
      ),
    );
  }

// @override
// void dispose() {
//   fullNameController.dispose();
//   emailController.dispose();
//   phoneController.dispose();
//   cityController.dispose();
//   areaNameController.dispose();
//   postalCodeController.dispose();
//   areaNameController.dispose();
//   super.dispose();
// }
}
