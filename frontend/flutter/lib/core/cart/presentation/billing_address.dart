import 'package:agro_millets/core/cart/presentation/add_shipping_address_page.dart';
import 'package:agro_millets/core/cart/presentation/payment_details.dart';
import 'package:agro_millets/models/billing_address.dart';
import 'package:agro_millets/models/user.dart'; // Import the User model
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/cache/app_cache.dart';
import '../../../models/cart_item.dart';
import '../../../models/millet_item.dart';
import '../../home/presentation/news/constants.dart';
import 'add_billing_address_page.dart'; // Import the BillingAddress model

class UnpaidPage extends ConsumerStatefulWidget {
  late final CartItem? selectedItem;

  UnpaidPage({required this.selectedItem});
  @override
  ConsumerState<UnpaidPage> createState() => _UnpaidPageState();
}

enum PaymentMethod {
  CashOnDelivery,
  // Esewa,
  Khalti
}

class _UnpaidPageState extends ConsumerState<UnpaidPage> {
  late PaymentMethod selectedPaymentMethod = PaymentMethod.Khalti;
  late CartItem selectedItem; // Declare the selectedItem variable

  // Add a user variable to store the user information
  User? user;

  @override
  void initState() {
    super.initState();
    // Retrieve the user information from the app state
    user = appState.value.user;
    selectedItem = widget.selectedItem!;
    getLocation();

  }

  BillingAddress? getFirstBillingAddress() {
    if (user != null && user!.billingAddresses.isNotEmpty) {
      return user!.billingAddresses[0];
    }
    return null;
  }

  BillingAddress? getFirstShippingAddress() {
    try {
      if (user != null && user!.billingAddresses.isNotEmpty) {
        print('----shipping address new fetch----');
        print(user!.billingAddresses[1]);
        return user!.billingAddresses[1];
      }
    } catch (e) {
      if (user != null && user!.billingAddresses.isNotEmpty) {
        return user!.billingAddresses[0];
      }
    }

    return null;
  }

  void _togglePaymentMethod(PaymentMethod? newMethod) {
    if (newMethod != null) {
      setState(() {
        selectedPaymentMethod = newMethod;
        if (selectedPaymentMethod == PaymentMethod.CashOnDelivery) {
          showSuccessToast('Cash on Delivery Selected');
        } else {
          showSuccessToast('Khalti Selected');
        }
      });
    }
  }

  void _onPayButtonPressed() {
    if (selectedPaymentMethod == PaymentMethod.CashOnDelivery) {
      // Handle Cash on Delivery payment logic
    } else if (selectedPaymentMethod == PaymentMethod.Khalti) {
      // Handle Khalti payment logic
    }
  }

  void _showPaymentModePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Payment Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: <Widget>[
                  Radio(
                    value: PaymentMethod.CashOnDelivery,
                    groupValue: selectedPaymentMethod,
                    onChanged: (newValue) {
                      _togglePaymentMethod(newValue);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  Text('Cash on Delivery'),
                ],
              ),
              Row(
                children: <Widget>[
                  Radio(
                    value: PaymentMethod.Khalti,
                    groupValue: selectedPaymentMethod,
                    onChanged: (newValue) {
                      _togglePaymentMethod(newValue);
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  Text('Khalti'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the popup
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  var locationName;

  Future<void> getLocation() async {
    String? name = await user?.getLocationName();
    setState(() {
      locationName = name;
    });
  }
  @override
  Widget build(BuildContext context) {



    Widget updateBillingAddressButton = GestureDetector(
      onTap: () async {
        final shouldRefreshBilling = await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) =>
                  AddBillingAddressPage()), // Adjust the route accordingly
        );
        if (shouldRefreshBilling == true) {
          final updatedUser = await appState
              .value.user; // Assuming you have a method to refresh user data
          setState(() {
            user = updatedUser;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(
          "Billing Address",
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
      ),
    );
    Widget updateShippingAddressButton = GestureDetector(
      onTap: () async {
        final shouldRefreshShipping = await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) =>
                  AddShippingAddressPage()), // Adjust the route accordingly
        );

        if (shouldRefreshShipping == true) {
          final updatedUser = await appState
              .value.user; // Assuming you have a method to refresh user data
          setState(() {
            user = updatedUser;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(
          "Shipping Address",
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
      ),
    );

    Widget continueButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PaymentPage(selectedItem:selectedItem)));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Text(
          "Continue",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
      ),
    );
    final billingAddress = getFirstBillingAddress();
    final shippingAddress = getFirstShippingAddress();
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) => SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Billing Address',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.account_balance_wallet),
                          //   onPressed: _showPaymentModePopup,
                          // ),
                          CloseButton()
                        ],
                      ),
                    ),
                    ClipRect(
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                              offset: Offset(0, 5),
                              blurRadius: 10.0,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Add labels and ListTile widgets with appropriate details
                            ListTile(
                              title: Text(
                                'Username',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              subtitle: Text(
                                '${billingAddress?.fullName}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Email',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              subtitle: Text(
                                '${billingAddress?.email}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Phone Number',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              subtitle: Text(
                                '${billingAddress?.phone}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Billing Address',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              subtitle: Text(
                                '${billingAddress?.areaName},${billingAddress?.province} ,${locationName} ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Shipping Address',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              subtitle: Text(
                                '${shippingAddress?.areaName},${shippingAddress?.province} ,${shippingAddress?.postalCode} ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            // Add more ListTiles as needed for the payment summary
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 16.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                updateBillingAddressButton,
                                Spacer(),
                                updateShippingAddressButton,
                              ],
                            ),
                            SizedBox(height: 10),
                            continueButton,
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}