import 'dart:convert';

import 'package:agro_millets/core/cart/presentation/esewa_pay.dart';
import 'package:agro_millets/core/cart/presentation/khalti_pay.dart';
import 'package:agro_millets/core/home/application/home_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../data/cache/app_cache.dart';
import '../../../globals.dart';
import '../../../models/cart_item.dart';
import '../../../models/millet_item.dart';
import '../../../models/order_item.dart';
import '../../../models/user.dart';
import '../../../secrets.dart';
import '../../order/presentation/order_page.dart';

class PaymentPage extends StatefulWidget {
  late final CartItem? selectedItem;

  PaymentPage({required this.selectedItem});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late CartItem selectedItem; // Declare the selectedItem variable
  MilletItem? selectedMilletItem; // Declare the selectedItem variable
  late int selectedPaymentOption;

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Payment Option'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text('Cash on Delivery'),
                    value: selectedPaymentOption == 0,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectedPaymentOption = 0;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('eSewa'),
                    value: selectedPaymentOption == 1,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectedPaymentOption = 1;
                          print(selectedPaymentOption);
                          print('---esewa clicked---');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Khalti'),
                    value: selectedPaymentOption == 2,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          selectedPaymentOption = 2;
                        }
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Pay'),
              onPressed: () async {
                User? farmer =
                    await getUser(selectedMilletItem?.listedBy ?? '');
                MilletOrder? order = await addItemOrder(
                  listedBy: appState.value.user!.id,
                  farmerId: selectedMilletItem?.listedBy ?? '',
                  quantity: selectedItem.count,
                  phoneFarmer: farmer!.phone,
                  phoneCustomer: appState.value.user!.phone,
                  quantityType: selectedMilletItem?.quantityType ?? '',
                  price: selectedItem.count * (selectedMilletItem?.price ?? 0),
                  item: selectedMilletItem?.id ?? '',
                  isPaid: false,
                  status: 'Processing', modeOfPayment: getPaymentMode(selectedPaymentOption),
                ).then((value) {
                  print('--------');
                  print(selectedPaymentOption);
                  if (selectedPaymentOption == 0) {
                    // cash on delivery
                    goToPage(context, const OrderPage());
                    // Navigator.of(context).pop();
                  }
                  if (selectedPaymentOption == 1) {
                    // esewa
                    goToPage(context, EsewaEpay(itemOrder: value,));
                  }
                  if (selectedPaymentOption == 2) {
                    // khaltipay
                    goToPage(context, KhaltiPay(itemOrder: value,));
                  }
                });
                // Payment logic here

                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  String getPaymentMode(int paymentOption) {
    switch (paymentOption) {
      case 0:
        return 'cash_on_delivery';
      case 1:
        return 'esewa';
      case 2:
        return 'khalti';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    // Retrieve the user information from the app state
    // user = appState.value.user;
    selectedItem = widget.selectedItem!;
    selectedPaymentOption = 0; // 0: Cash on Delivery, 1: eSewa, 2: Khalti
    getMilletItemById();
  }

  getMilletItemById() async {
    selectedMilletItem = await getItemById(selectedItem.item) as MilletItem;

    setState(()  {
      selectedMilletItem = selectedMilletItem;
    });
  }

  Future<User?> getUser(String id) async {
    var response = await http.post(
      Uri.parse("$API_URL/auth/getUser"),
      body: {"id": id},
    );

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      if (data["statusCode"] == 200) {
        return User.fromMap(data["data"]);
      }
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    Widget payNow = InkWell(
      onTap: _showPaymentDialog, // Show the payment dialog
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
            ),
          ],
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Center(
          child: Text(
            "Pay Now",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );

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
                            'Payment Details',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CloseButton()
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                            offset: Offset(0, 5),
                            blurRadius: 10.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text('Product Name'),
                            trailing: Text('${selectedMilletItem?.name}'),
                          ),
                          ListTile(
                            title: Text('Farmer Name'),
                            trailing: Text('${selectedMilletItem?.farmer}'),
                          ),
                          ListTile(
                            title: Text('Quantity'),
                            trailing: Text('${selectedItem.count}'),
                          ),
                          ListTile(
                            title: Text('Price/item'),
                            trailing: Text('${selectedMilletItem?.price}'),
                          ),
                          ListTile(
                            title: Text('Mode of payment'),
                            trailing: Text('Cash on Delivery'),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              'रू ${selectedItem.count * (selectedMilletItem?.price ?? 0)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: payNow,
                    ),
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
