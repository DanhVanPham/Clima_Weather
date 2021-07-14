import 'package:clima_app/services/location.dart';
import 'package:clima_app/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({required this.location});
  final Location location;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition initialPosition;
  late LatLng latLng;
  void getCurrentLocation() async {
    initialPosition = CameraPosition(
        target: LatLng(
            widget.location.getLatitude(), widget.location.getLongitude()),
        zoom: 11.0,
        tilt: 0,
        bearing: 0);
  }

  late Set<Marker> myMarker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    myMarker = Set.from([]);
  }

  _handleTap(LatLng pos) {
    setState(() {
      myMarker.add(Marker(
        markerId: MarkerId("1"),
        position: pos,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topLeft,
                child: FlatButton(
                  child: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: GoogleMap(
                markers: myMarker,
                onTap: (pos) {
                  latLng = pos;
                  _handleTap(pos);
                },
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: initialPosition,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(context, latLng);
                },
                child: Text(
                  'Get Weather',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Spartan MB',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
