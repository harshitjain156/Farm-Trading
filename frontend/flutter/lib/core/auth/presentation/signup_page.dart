import 'package:agro_millets/core/auth/application/auth.dart';
import 'package:agro_millets/core/auth/presentation/login_page.dart';
import 'package:agro_millets/core/auth/presentation/phone_otp.dart';
import 'package:agro_millets/core/auth/presentation/phone_verify.dart';
import 'package:agro_millets/core/home/presentation/news/constants.dart';
import 'package:agro_millets/core/home/presentation/widgets/loading_widget.dart';
import 'package:agro_millets/globals.dart';
import 'package:agro_millets/main.dart';
import 'package:agro_millets/widgets/action_button.dart';
import 'package:agro_millets/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final String phone;
  const SignUpPage({Key? key,required this.phone}) : super(key: key);
  // const SignUpPage(this.phone, {super.key});


  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late AuthManager _authManager;
  String dropdownValue = "wholesaler";
  String email = "", password = "", username = "", phone = "";
  MapController mapController = MapController();
  List<LatLng> selectedCoordinates = [];

  get hasError => null;


  @override
  void initState() {
    _authManager = AuthManager(context, ref);
    // showSuccessToast('Your Phone Number Is Verified');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      isLoading: _authManager.isLoading,
      child: _getSignUpPage(context),
    );

  }

  SingleChildScrollView _getSignUpPage(BuildContext context) {
    List<Marker> buildMarkers() {
      if (selectedCoordinates.isEmpty) {
        return [Marker(point:LatLng(27.694549317783395, 85.32055500746131),builder: (BuildContext context) {
          return Icon(Icons.location_on, color: Colors.red);
        },)];
      }
      return [
      Marker(
        point: selectedCoordinates.last,
        builder: (BuildContext context) {
          return Icon(Icons.location_on, color: Colors.red);
        },
      )
      ];
      return selectedCoordinates.map((LatLng latLng) {

      }).toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          Image.asset(
            "assets/logo_app.png",
            height: 100,
            width: 100,
          ),
          SizedBox(height: 0.015 * getHeight(context)),
          const Center(
            child: Text(
              "Farm Trading",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: Text(
              "Cut the middle man between farmers and wholesalers",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 0.025 * getHeight(context)),
          CustomTextField(
            onChanged: (v) => username = v,
            label: "Username",
          ),
          const SizedBox(height: 10),
          CustomTextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => email = v,
            label: "Email",
          ),
          const SizedBox(height: 10),
          CustomTextField(
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
            onChanged: (v) => password = v,
            label: "Password",
            //errorText: hasError ? "Invalid password" : null,
          ),
          // const SizedBox(height: 10),
          // CustomTextField(
          //   keyboardType: TextInputType.phone,
          //   onChanged: (v) => phone = v,
          //   label: "Phone",
          // ), // Add this condition
          _getUserTypeDropDown(context),
          const Center(
            child: Text(
              "Pick your location in the map",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            height: 200, // Set the desired height for the map
            width: 500, // Set the width to match the parent widget or provide a fixed width
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,

                  options: MapOptions(
                    center: LatLng(27.694549317783395, 85.32055500746131),
                    zoom: 18,
                    minZoom: 2, // Set the minimum zoom level
                    maxZoom: 18,
                    onTap: (mapController,LatLng latLng) {
                      setState(() {
                        selectedCoordinates.add(latLng);
                      });
                    },
                    // Set the maximum zoom level
                  ),

                  children: [
                    TileLayer(
                      urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoidmVzaGciLCJhIjoiY2xobHo4OXlpMTcwMDNzcGhzZ2wxZmtzZSJ9.fV25khQviUGZ14rLQC__tw',
                      userAgentPackageName: 'com.example.agro_millets',
                    ),

                    MarkerLayer(
                      markers: buildMarkers(),
                    ),

                  ],

                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          mapController.move(mapController.center,18);
                        },
                        child: Icon(Icons.add),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () {
                          mapController.move(mapController.center,8);
                        },
                        child: Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.025 * getHeight(context)),
          ActionButton(
            isFilled: false,
            onPressed: () async {
              goToPage(
                context,
                 MyPhone(email: email, name: username, password: password, coordinate: selectedCoordinates.last, userType: dropdownValue ,),

                clearStack: true,
              );

            },
            text: "Continue",
          ),
          // SizedBox(height: 0.015 * getHeight(context)),
          // GestureDetector(
          //   onTap: () async {
          //     var res = await _authManager.googleAuth();
          //     if (res == 1 && mounted) {
          //       goToPage(context, const RolePage(), clearStack: true);
          //     }
          //   },
          //   child: Container(
          //     height: 0.06 * getHeight(context),
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: const [
          //         Icon(
          //           MdiIcons.google,
          //           color: Colors.white,
          //         ),
          //         // SizedBox(width: 10),
          //         // Text(
          //         //   "Sign up using Google",
          //         //   style: TextStyle(
          //         //     color: Colors.white,
          //         //     fontSize: 16,
          //         //   ),
          //         // )
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 0.015 * getHeight(context)),
          GestureDetector(
            onTap: () => goToPage(
              context,
              const LoginPage(),
              clearStack: true,
            ),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: "Already have an account?"),
                  TextSpan(
                    text: " Login",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getUserTypeDropDown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField(
        value: dropdownValue,
        items: const [
          DropdownMenuItem(value: "wholesaler", child: Text("Wholesaler")),
          DropdownMenuItem(value: "farmer", child: Text("Farmer")),
        ],
        onChanged: (v) {
          dropdownValue = v ?? dropdownValue;
          setState(() {});
        },
      ),
    );
  }

}
