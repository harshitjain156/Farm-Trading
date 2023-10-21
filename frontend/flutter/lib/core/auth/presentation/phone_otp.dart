import 'dart:convert';
import 'dart:math';

import 'package:agro_millets/core/auth/presentation/phone_verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import '../../home/presentation/news/constants.dart';
import '../application/auth.dart';
import '../../../globals.dart';
import 'package:http/http.dart' as http;
import "package:agro_millets/secrets.dart";

class MyPhone extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  // final String phone;
  final LatLng coordinate;
  final String userType;

  MyPhone({
    Key? key,
    required this.email,
    required this.name,
    required this.password,
    required this.coordinate,
    required this.userType,
  }) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class VerificationData {
  static String verificationId = '';
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  var verificationId = ''.obs;

  // static String verificationId = '';

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+977";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            // Limit input to 10 characters
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                  ],
                ),
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
                      String phone =
                          countryController.text + ' ' + _phoneController.text;
                      bool? isDuplicatePhone =  await searchForDuplicatePhone(phone);
                      if (!isDuplicatePhone!) {
                        // await phoneAuthentication(phone);
                        // print(phone_number_verified);
                        // print('-----');

                        // Note that using a username and password for gmail only works if
                        // you have two-factor authentication enabled and created an App password.
                        // Search for "gmail app password 2fa"
                        // The alternative is to use oauth.
                        String username = 'tardefarm@gmail.com';
                        String password = 'okzkjbjchdrjmbjm';

                        final smtpServer = gmail(username, password);
                        // Use the SmtpServer class to configure an SMTP server:
                        // final smtpServer = SmtpServer('smtp.domain.com');
                        // See the named arguments of SmtpServer for further configuration
                        // options.
                        Random random = Random();
                        int min = 100000; // Minimum 6-digit number
                        int max = 999999; // Maximum 6-digit number
                        int verificationPin = min + random.nextInt(max - min + 1);
                        // Create our message.
                        final message = Message()
                          ..from = Address(username, 'Farm Trading')
                          ..recipients.add(this.widget.email)
                        // ..ccRecipients.addAll([])
                        // ..bccRecipients.add(Address('bccAddress@example.com'))
                          ..subject = 'your verification code::${verificationPin}'
                          ..text = '${verificationPin}'
                          ..html = "<p>Pin verification</p>\n <h2>${verificationPin}</h2>";

                        try {
                          final sendReport = await send(message, smtpServer);
                          print('Message sent: ' + sendReport.toString());
                        } on MailerException catch (e) {
                          print('Message not sent.');
                          for (var p in e.problems) {
                            print('Problem: ${p.code}: ${p.msg}');
                          }
                        }
                        goToPage(
                            context,
                            MyVerify(
                              // verificationId: this.verificationId.value,
                              verificationPin: verificationPin,
                              phone: phone,
                              name: this.widget.name,
                              password: this.widget.password,
                              coordinate: this.widget.coordinate,
                              userType: this.widget.userType,
                              email: this.widget.email,
                            ));
                      } else {
                        showFailureToast('Phone Number Already Registered !');

                      }

                      // Navigator.pushNamed(context, 'verify');
                    },
                    child: Text("Send the code")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendOTPCode(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        VerificationData.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout error if needed
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
    );
  }
  Future<bool?> searchForDuplicatePhone(String phone) async {
    var response = await http.post(
      Uri.parse("$API_URL/auth/phoneExists"),
      body: {"phone": phone},
    );

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      if (data["statusCode"] == 200) {
        return false;
      }
    }
    return true;
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    print(phoneNo);
    await _auth.verifyPhoneNumber(
        phoneNumber: '${phoneNo.substring(0, 7) + '-' + phoneNo.substring(7)}',
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            print('the provided no is not valid');
          } else {
            print('Something Went Wrong. Try Again');
          }
        },
        codeSent: (verificationId, resendToken) async {
          print('The Code has been sent.......');
          this.verificationId.value = verificationId;
          // await verifyOTP('123456');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          print('The Code retrieval timout.......');

          this.verificationId.value = verificationId;
        });
  }
// Future<bool>verifyOTP(String otp) async {
//   print(verificationId.value);
//   print('------');
// var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
// return credentials.user != null ? true:false;
}