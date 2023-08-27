import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class MapScreen extends StatelessWidget {
  final Function(double, double, String) onAddressPicked;

  const MapScreen({super.key, required this.onAddressPicked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Location'),
        ),
        body: FlutterLocationPicker(
            initPosition: const LatLong(23, 89),
            selectLocationButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
            selectLocationButtonText: 'Set Current Location',
            selectLocationButtonLeadingIcon: const Icon(Icons.check),
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            trackMyPosition: true,
            onPicked: (pickedData) {
              onAddressPicked(pickedData.latLong.latitude, pickedData.latLong.longitude, pickedData.address);
            }));
  }
}
