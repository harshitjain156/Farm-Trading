import 'package:agro_millets/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinput/pinput.dart';

import '../../../main.dart';
import '../../../models/billing_address.dart';
import '../../home/presentation/news/constants.dart';
import '../application/auth.dart';

class MyVerify extends ConsumerStatefulWidget {
  // final String verificationId;
  final int verificationPin;
  final String phone;

  final String name;

  final String email;

  final String password;
  final LatLng coordinate;
  final String userType;

  const MyVerify({
    Key? key,
    required this.verificationPin,
    required this.phone,
    required this.name,
    required this.password,
    required this.coordinate,
    required this.userType,
    required this.email,
  }) : super(key: key);

  @override
  ConsumerState<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends ConsumerState<MyVerify> {
  String pinValue = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _pinController = TextEditingController();
  Key _pinputKey = UniqueKey();
  late AuthManager _authManager;

  @override
  void initState() {
    _authManager = AuthManager(context, ref);
    // showSuccessToast('Your Phone Number Is Verified');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_app.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                key: _pinputKey,
                controller: _pinController,
                showCursor: true,
                onCompleted: (pin) => pinValue = pin,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      // PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      //   verificationId: this.widget.verificationId,
                      //   smsCode: pinValue,
                      // );
                      try {
                        // var credentials = await _auth.signInWithCredential(credential);
                        // print(credentials);
                        // bool success = credentials.user != null ? true:false;
                        if (this.widget.verificationPin.toString() ==
                            pinValue) {
                          showSuccessToast('Pin Verified Successfully');

                          try {
                            final billingAddress = BillingAddress(
                              province: '',
                              city: '',
                              areaName: '',
                              fullName: this.widget.name.trim(),
                              email: this.widget.email,
                              postalCode: '',
                              phone: this.widget.phone,
                              category: 'billing',
                              isDefaultBilling: true,
                              isDefaultShipping: true,
                            );
                            var res =
                                await _authManager.signUpUsingEmailPassword(
                              email: this.widget.email,
                              name: this.widget.name.trim(),
                              password: this.widget.password.trim(),
                              phone: this.widget.phone.trim(),
                              coordinate: this.widget.coordinate,
                              userType: this.widget.userType,
                              billingAddress:
                                  billingAddress, // Include the billing address object
                            );
                            if (res == 1 && mounted) {
                              goToPage(context, RolePage(), clearStack: true);
                            }
                          } catch (e) {
                            showFailureToast("${e}");
                          }

                          // goToPage(context, SignUpPage(phone:this.widget.phone));
                        }
                      } catch (e) {
                        _pinController.clear();
                        _pinputKey = UniqueKey();
                        showFailureToast('Invalid Verification Pin');
                      }
                      // print('Finally Pin verified');
                      // print(value);
                    },
                    child: Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'phone',
                        (route) => false,
                      );
                    },
                    child: SizedBox.shrink(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
