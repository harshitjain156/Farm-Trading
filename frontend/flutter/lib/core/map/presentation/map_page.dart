import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:agro_millets/core/map/application/map_manager.dart';
import 'package:agro_millets/core/map/application/map_provider.dart';
import 'package:agro_millets/data/cache/app_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../../../models/user.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late MapManager mapManager;
  MapController mapController = MapController();
  List<LatLng> farmerCoordinates = [];
  var logged_in_user = appState.value.user;
  late LatLng map_latlng_view =
      LatLng(logged_in_user!.latitude, logged_in_user!.longitude);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<OSMdata> _options = <OSMdata>[];

  @override
  void initState() {
    mapManager = MapManager(context, ref);
    super.initState();
  }
  List<Marker> markers = [];
  LatLng? selectedLocation;
  String? selectedLocationName;
  List<Marker> buildMarkers(selectedLocation,selectedLocationName) {
    List<User> map = ref.watch(mapProvider).getMap();
    if (map.isEmpty) {
      return [
        Marker(
          point: LatLng(27.694549317783395, 85.32055500746131),
          builder: (BuildContext context) {
            return Icon(Icons.location_on, color: Colors.red);
          },
        )
      ];
    }

    // Define geographic boundaries for your target area
    double? minLatitude = logged_in_user?.latitude;
    double maxLatitude = minLatitude! + 0.5;
    double? minLongitude = logged_in_user?.longitude;
    double maxLongitude = minLongitude! + 0.5;

    var markers =
    map.where((user) {
      if (!appCache.isAdmin())
      {
        return user.userType == 'farmer' &&
            user.latitude >= minLatitude &&
            user.latitude <= maxLatitude &&
            user.longitude >= minLongitude &&
            user.longitude <= maxLongitude;
      }
      else {
        return true;
      }
    }

    ).map((User user) {
      Coordinate coord1 =
      Coordinate(user.latitude, user.longitude); // Berlin coordinates
      Coordinate coord2 = Coordinate(logged_in_user?.latitude,
          logged_in_user?.longitude); // Paris coordinates

      double distance = distanceBetweenCoordinates(coord1, coord2);

      return Marker(
        point: LatLng(user.latitude, user.longitude),
        builder: (ctx) => GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                // contentPadding: EdgeInsets.zero, // Remove default padding
                title: Row(
                  // Remove default padding
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      // color: Colors.,
                    ),
                    SizedBox(width: 5),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.category_outlined),
                          SizedBox(width: 5),
                          Text(
                            user.userType,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Icon(Icons.category_outlined),
                          Icon(Icons.nordic_walking_outlined),
                          SizedBox(width: 5),
                          Text(
                            distance.toStringAsFixed(2) + " KM",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone_android_outlined),
                          // Container(
                          //   // padding: EdgeInsets.only(right: 5.0), // Adjust the left padding as needed
                          //   child:
                          // )
                          // ,
                          // SizedBox(width: 5),
                          Text(
                            user.phone,
                            style: TextStyle(fontSize: 16),
                          ),
                          // IconButton(
                          //   padding: EdgeInsets.only(right: 0.0),
                          //   onPressed: () => UrlLauncher.launch('tel://${user.phone}'),
                          //   icon: const Icon(MdiIcons.phoneDial,color: Colors.green,),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: OverflowBox(
            minWidth: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: Column(
              children: [
                Container(
                  color: Colors.white, // Background color
                  child: Text(
                    distance.toStringAsFixed(1) + " KM",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue, // Font color
                    ),
                  ),
                ),
                Icon(Icons.location_on, color: Colors.red),
                // SizedBox(width: 8),
              ],
            ),
          ),
          // By wrapping the Row with Expanded, it will take up the available space horizontally and prevent overflow issues.
        ),
        // builder: (BuildContext context) {
        //   return Icon(Icons.location_on, color: Colors.red);
        // },
      );
    }).toList();
    markers.add(Marker(
      point: LatLng(logged_in_user!.latitude, logged_in_user!.longitude),
      builder: (ctx) => GestureDetector(
        child: OverflowBox(
          minWidth: 0,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Column(
            children: [
              Container(
                color: Colors.white, // Background color
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue, // Font color
                  ),
                ),
              ),
              Icon(Icons.location_on, color: Colors.green),
              // SizedBox(width: 8),
            ],
          ),
        ),
        // By wrapping the Row with Expanded, it will take up the available space horizontally and prevent overflow issues.
      ),
      // builder: (BuildContext context) {
      //   return Icon(Icons.location_on, color: Colors.red);
      // },
    ));
    if (selectedLocation !=null ) {
      markers.add(Marker(
        point: selectedLocation,
        builder: (ctx) => GestureDetector(
          child: OverflowBox(
            minWidth: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: Column(
              children: [
                Container(
                  color: Colors.white, // Background color
                  child: Text(
                    selectedLocationName.split(" ")[0],
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue, // Font color
                    ),
                  ),
                ),
                Icon(Icons.location_on, color: Colors.blue),
                // SizedBox(width: 8),
              ],
            ),
          ),
          // By wrapping the Row with Expanded, it will take up the available space horizontally and prevent overflow issues.
        ),
        // builder: (BuildContext context) {
        //   return Icon(Icons.location_on, color: Colors.red);
        // },
      ));

    }
    return markers;
  }
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    );
    OutlineInputBorder inputFocusBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 3.0),
    );

    double zoomLevel=11;
    markers = buildMarkers(selectedLocation,selectedLocationName);
    return Scaffold(
    appBar: AppBar(
        title: const Text("Farmers Near You"),
      ),
      body: Column(
      children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search Location',
                        border: inputBorder,
                        focusedBorder: inputFocusBorder,
                      ),
                      onChanged: (String value) {
                        if (_debounce?.isActive ?? false) _debounce?.cancel();

                        _debounce =
                            Timer(const Duration(milliseconds: 2000), () async {
                          if (kDebugMode) {
                            print(value);
                          }
                          var client = http.Client();
                          try {
                            String url =
                                'https://nominatim.openstreetmap.org/search?q=$value&format=json&polygon_geojson=1&addressdetails=1';
                            if (kDebugMode) {
                              print(url);
                            }
                            var response = await client.get(Uri.parse(url));
                            print(utf8.decode(response.bodyBytes));
                            print('========');
                            var decodedResponse =
                                jsonDecode(utf8.decode(response.bodyBytes))
                                    as List<dynamic>;
                            if (kDebugMode) {
                              print(decodedResponse);
                            }
                            _options = decodedResponse
                                .map((e) => OSMdata(
                                    displayname: e['display_name'],
                                    lat: double.parse(e['lat']),
                                    lon: double.parse(e['lon'])))
                                .toList();
                            setState(() {});
                          } finally {
                            client.close();
                          }

                          setState(() {});
                        });
                      }),
                  StatefulBuilder(builder: ((context, setState) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _options.length > 5 ? 5 : _options.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_options[index].displayname),
                            subtitle: Text(
                                '${_options[index].lat},${_options[index].lon}'),
                            onTap: () {
                              selectedLocation =  LatLng(
                                  _options[index].lat, _options[index].lon);
                              selectedLocationName=_options[index].displayname;
                              mapController.move(
                                  selectedLocation!,
                                  9.0);
                              setState(() {
                                // Add new markers to the list
                                // selectedLocation=LatLng(
                                //     _options[index].lat, _options[index].lon);
                                // markers.add(
                                //   Marker(
                                //     point:  selectedLocation!, // New marker's position
                                //     builder: (BuildContext context) {
                                //       return Icon(
                                //         Icons.location_pin,
                                //         size: 20,
                                //         color: Colors.blue,
                                //       );
                                //     },
                                //   ),
                                // );

                                // Add more markers as needed

                                // The widget will be rebuilt with the updated markers list
                              });

                              _focusNode.unfocus();
                              _options.clear();
                            },
                          );
                        });
                  })),
                ],
              )),
          Expanded(

            child: SizedBox(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: map_latlng_view,
                      zoom: zoomLevel,
                      minZoom: 2, // Set the minimum zoom level
                      maxZoom: 18,
                      // onTap: (mapController,LatLng latLng) {
                      //   setState(() {
                      //     farmerCoordinates.add(latLng);
                      //   });
                      // },
                      // Set the maximum zoom level
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoidmVzaGciLCJhIjoiY2xobHo4OXlpMTcwMDNzcGhzZ2wxZmtzZSJ9.fV25khQviUGZ14rLQC__tw',
                        userAgentPackageName: 'com.example.agro_millets',
                      ),

                      MarkerLayer(
                        markers: markers,
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
                            zoomLevel += 0.5;
                            mapController.move(mapController.center, zoomLevel);
                          },
                          child: Icon(Icons.add),
                        ),
                        SizedBox(height: 10),
                        FloatingActionButton(
                          onPressed: () {
                            zoomLevel -= 0.5;
                            mapController.move(mapController.center, zoomLevel);
                          },
                          child: Icon(Icons.remove),
                        ),
                      ],
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

  @override
  void dispose() {
    mapManager.dispose();
    super.dispose();
  }
}

class Coordinate {
  final double? latitude;
  final double? longitude;

  Coordinate(this.latitude, this.longitude);
}

double distanceBetweenCoordinates(Coordinate coord1, Coordinate coord2) {
  const double earthRadius = 6371; // Radius of the Earth in kilometers

  double degToRad(double? degree) {
    return degree! * (pi / 180);
  }

  double lat1 = degToRad(coord1.latitude);
  double lon1 = degToRad(coord1.longitude);
  double lat2 = degToRad(coord2.latitude);
  double lon2 = degToRad(coord2.longitude);

  double dlat = lat2 - lat1;
  double dlon = lon2 - lon1;

  double a =
      pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;
  return distance;
}
