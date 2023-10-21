// import 'dart:convert';
// import 'dart:io';
// import 'package:agro_millets/core/home/application/home_manager.dart';
// import 'package:agro_millets/core/home/presentation/widgets/loading_widget.dart';
// import 'package:agro_millets/data/cache/app_cache.dart';
// import 'package:agro_millets/utils/firebase_storage.dart';
// import 'package:agro_millets/widgets/action_button.dart';
// import 'package:flutter/material.dart';
// import 'package:agro_millets/globals.dart';
// import '../../../models/millet_item.dart';
// import '../../../models/user.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../secrets.dart';
//
// class AddItemOrderPage extends StatefulWidget {
//   final HomeManager homeManager;
//   final MilletItem milletItem;
//
//   const AddItemOrderPage(
//       {Key? key, required this.homeManager, required this.milletItem})
//       : super(key: key);
//
//   @override
//   AddItemOrderPageState createState() => AddItemOrderPageState();
// }
//
// class AddItemOrderPageState extends State<AddItemOrderPage> {
//   late double height, width;
//
//   String name = "",
//       description = "",
//       category = "fruits",
//       quantityType = "kg";
//
//
//   double price = 0.0,
//       quantity = 0.0;
//   String imageUrl = "";
//   bool pickedImage = false;
//
//   ValueNotifier<bool> isLoading = ValueNotifier(false);
//
//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery
//         .of(context)
//         .size
//         .height;
//     width = MediaQuery
//         .of(context)
//         .size
//         .width;
//     return LoadingWidget(
//       isLoading: isLoading,
//       child: _getAddItemOrderPage(context),
//     );
//     // return _getAddItemOrderPage(context);
//   }
//
//   Scaffold _getAddItemOrderPage(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Add Your order",
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: _getFloatingActionButton(context),
//       body: _getBody(),
//     );
//   }
//
//   _getFloatingActionButton(BuildContext context) {
//     return FloatingActionButton.extended(
//       onPressed: () async {
//         User? farmer = await getUser(widget.milletItem.listedBy);
//         // String orderId = const Uuid().v1();
//
//         // String url = await storageManager.uploadItemImage(itemId, File(imageUrl));
//         // String url = "https://firebasestorage.googleapis.com/v0/b/kisan-7ffff.appspot.com/o/images%2Fitems%2FMaize_mccornick.org_.jpg?alt=media&token=0ca55aad-eb86-45ff-93a2-fa820fa9c5a0";
//         if (quantity <= widget.milletItem.quantity) {
//           isLoading.value = true;
//           await addItemOrder(
//               listedBy: appState.value.user!.id,
//               farmerId: widget.milletItem.listedBy,
//               quantity: quantity,
//               phoneFarmer:farmer!.phone,
//               phoneCustomer:appState.value.user!.phone,
//               quantityType: widget.milletItem.quantityType,
//               price: quantity * widget.milletItem.price,
//               item: widget.milletItem.id, isDelivered: false
//           );
//           isLoading.value = false;
//           if (mounted) {
//             Navigator.pop(context);
//           }
//         } else {
//           showToast("Quantity most be below ${widget.milletItem.quantity}");
//         }
//
//       },
//       label: Row(
//         children: const [
//           Text("Continue"),
//           SizedBox(width: 5),
//           Icon(
//             Icons.arrow_forward_ios,
//             size: 14,
//           ),
//         ],
//       ),
//     );
//   }
//   Future<User?> getUser(String id) async {
//     var response = await http.post(
//       Uri.parse("$API_URL/auth/getUser"),
//       body: {"id": id},
//     );
//
//     if (response.body.isNotEmpty) {
//       var data = json.decode(response.body);
//       if (data["statusCode"] == 200) {
//         return User.fromMap(data["data"]);
//       }
//     }
//     return null;
//   }
//
//
//   _getBody() {
//     return SingleChildScrollView(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15.0),
//         height: height,
//         child: Column(
//           children: [
//             SizedBox(height: 0.02 * height),
//             AnimatedSwitcher(
//               duration: const Duration(seconds: 1),
//               reverseDuration: const Duration(seconds: 1),
//               child: _getImageSelector(),
//               layoutBuilder: (currentChild, previousChildren) =>
//               currentChild ?? Container(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _getImageSelector() {
//     return Column(
//       children: [
//         Container(
//           height: 0.025 * height,
//         ),
//         _getTextField(
//           "Quantity less than ${widget.milletItem.quantity}",
//           ((e) => quantity = double.parse(e)),
//           TextInputType.number,
//         ),
//         // _getTextField(
//         //   "Price (Rs.)",
//         //   ((e) => price = double.parse(e)),
//         //   TextInputType.number,
//         // ),
//       ],
//     );
//   }
//
//   _getTextField(String hintText,
//       Function onChange,
//       TextInputType keyboardType,) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10.0),
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10.0,
//         vertical: 5.0,
//       ),
//       decoration: BoxDecoration(
//         color: Theme
//             .of(context)
//             .cardColor,
//         borderRadius: BorderRadius.circular(8.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.025),
//             spreadRadius: 1.0,
//             blurRadius: 8.0,
//           ),
//         ],
//       ),
//       child: TextFormField(
//         maxLines: null,
//         keyboardType: TextInputType.multiline,
//         onChanged: (value) {
//           onChange(value);
//           setState(() {});
//         },
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: InputBorder.none,
//         ),
//         // validator: _textFieldValidator,
//       ),
//     );
//   }
// }
//
// // String? _textFieldValidator(String? value) {
// //   // Perform your validation here
// //   // For example, you can check if the value is empty or doesn't meet specific requirements.
// //   if (value == null || value.isEmpty) {
// //     return 'Please enter a value.';
// //   }
// //
// //   // Add more validation conditions as needed.
// //
// //   return null; // Return null if the input is valid.
// // }