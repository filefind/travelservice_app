import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: HitMap(),
  ));
}

class HitMap extends StatefulWidget {
  const HitMap({Key key}) : super(key: key);
  @override
  _StateMap createState() => new _StateMap();
}

class _StateMap extends State<HitMap> with SingleTickerProviderStateMixin {
  var isLoading = false;
  GoogleMap mMap;
  _fetchData() async {
    final response = await http.get("http://tr.telenet.ru:81/skycatch.php?action=countries");
    if (response.statusCode == 200) {
      var d = json.decode(response.body);
      var d1 = d["result"];
      print("Country Length: "+d1.length.toString());
//      litems=d1;
      setState(() {isLoading = true;});
    } else {
      throw Exception('Failed to load countries');
    }
  }
  @override
  void initState() {
    super.initState();

    Completer<GoogleMapController> _controller = Completer();
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962),
      zoom: 14.4746,
    );
    mMap = new GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
//          _controller.complete(controller);
        }
    );
//    Completer<GoogleMapController> _controller = Completer();
//    final CameraPosition _kGooglePlex = CameraPosition(
//      target: LatLng(37.42796133580664, -122.085749655962),
//      zoom: 14.4746,
//    );

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(!isLoading) {
      _fetchData();
//      final CameraPosition _kLake = CameraPosition(
//          bearing: 192.8334901395799,
//          target: LatLng(37.43296265331129, -122.08832357078792),
//          tilt: 59.440717697143555,
//          zoom: 19.151926040649414);

//    Future<void> _goToTheLake() async {
//      final GoogleMapController controller = await _controller.future;
//      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//    }

    }
  }

}