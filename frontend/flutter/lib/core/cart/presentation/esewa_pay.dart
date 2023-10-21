import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agro_millets/core/cart/presentation/cart_page.dart';
import 'package:agro_millets/core/home/presentation/news/constants.dart';
import 'package:agro_millets/core/home/presentation/widgets/agro_item_order.dart';
import 'package:agro_millets/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../models/order_item.dart';
import '../../../secrets.dart';
import '../../order/presentation/order_page.dart';

class EsewaEpay extends StatefulWidget {
  late final MilletOrder? itemOrder;
  EsewaEpay({required this.itemOrder});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<EsewaEpay> {
  int onPageFinishedCount = 0; // Counter to keep track of onPageFinished calls
  Completer<WebViewController> _controller = Completer<WebViewController>();
  MilletOrder? itemOrder; // Declare the selectedItem variable

  late WebViewController _webViewController;

  String testUrl = "https://pub.dev/packages/webview_flutter";

  _loadHTMLfromAsset() async {
    String file = await rootBundle.loadString("assets/epay_request.html");
    _webViewController.loadUrl(Uri.dataFromString(file,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }




  @override
  void initState() {
    super.initState();
    try {
      itemOrder = widget.itemOrder!;

    } catch(e) {
      goToPage(context, CartPage());
      showFailureToast('Payment Failure');
    }
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }





  @override
  Widget build(BuildContext context) {
    // ePay deatils
    double amt = itemOrder?.price ?? 0.0 ;
    double txAmt = amt * 0.25;
    double psc = 10;
    double pdc = 50;
    double tAmt = txAmt + amt + psc + pdc;
    String scd = "EPAYTEST";
    String su = "$API_URL/auth/payment-success/${itemOrder?.id}";
    String fu = "$API_URL/auth/payment-success";

    Future<void> fetchData(String url) async {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Request was successful, and the response is stored in 'response.body'
        print('Response data: ${response.body}');
      } else {
        // Request failed or returned a non-200 status code
        print('Request failed with status: ${response.statusCode}');
      }
    }

    return Scaffold(

      appBar: AppBar(
        leading: SizedBox.shrink(),
      ),
      body: WebView(
        initialUrl: 'https://rc-epay.esewa.com.np',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
            name: "message",
            onMessageReceived: (message) {},
          ),
        ]),
        onPageFinished: (data) async {
          onPageFinishedCount++;
          setState(() {
            String pid = UniqueKey().toString();
            _webViewController.runJavascript(
                'requestPayment(tAmt = $tAmt, amt = $amt, txAmt = $txAmt, psc = $psc, pdc = $pdc, scd = "$scd", pid = "$pid", su = "$su", fu = "$fu")');
          });
        },
        onWebViewCreated: (webViewController) {
          // _controller.complete(webViewController);
          _webViewController = webViewController;
          _loadHTMLfromAsset();
        },
        navigationDelegate: (NavigationRequest request) async {
          print('---URL---');
          print(request.url);
          if (request.url.contains("payment-success")) {

            var a = await fetchData(request.url);
            showSuccessToast('Payment Success !');

            // Redirect after receiving response from speci fic URL
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OrderPage()),
            );

            // Return NavigationDecision.prevent to prevent loading the URL
            return NavigationDecision.prevent;
          }
          if (request.url == fu) {
            showFailureToast('Payment Failure. Try again !');
            // Redirect after receiving response from specific URL
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EsewaEpay(itemOrder: itemOrder,)),
            );

            // Return NavigationDecision.prevent to prevent loading the URL
            return NavigationDecision.prevent;
          }

          // Allow navigation for other URLs
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
