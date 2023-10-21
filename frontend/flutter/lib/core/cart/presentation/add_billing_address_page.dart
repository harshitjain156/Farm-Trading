import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:flutter/material.dart';
import '../../../models/billing_address.dart';
import '../../../models/user.dart';
import '../../auth/application/auth.dart';
import 'address_form.dart';
import 'billing_address.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBillingAddressPage extends ConsumerStatefulWidget {
  const AddBillingAddressPage({super.key});

  @override
  ConsumerState<AddBillingAddressPage> createState() => _AddBillingAddressPageState();
}

class _AddBillingAddressPageState extends ConsumerState<AddBillingAddressPage> {
  late AuthManager _authManager;
  String email = "", password = "";
  User? user;

  @override
  void initState() {
    _authManager = AuthManager(context, ref);
    super.initState();
    user = appState.value.user;
  }

  BillingAddress? getFirstBillingAddress() {
    if (user != null && user!.billingAddresses.isNotEmpty) {
      return user!.billingAddresses[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final billingAddress = getFirstBillingAddress();
    print(billingAddress?.toJson());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey[800]),
        title: Text(
          'Billing Details',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Montserrat",
            fontSize: 25.0,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AddAddressForm(billingAddress: billingAddress!, category: 'billing',)
                  ,
                  SizedBox(height: 10), // Add a small space
                  // Center(child: finishButton),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
