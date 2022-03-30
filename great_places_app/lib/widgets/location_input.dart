import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helpers.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  LocationInput(this.onSelectPlace);

  final Function onSelectPlace;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override
  Widget build(BuildContext context) {
    late String _previewImageUrl;

    // refactored method for reuse
    void _showPreview(
      double lat,
      double lng,
    ) {
      final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat,
        longitude: lng,
      );

      // setState to update the ui for image changes
      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });
    }

    Future<void> _getCurrentUserLocation() async {
      // try catch method if the user deny the permission
      try {
        final locData = await Location().getLocation();

        // use the refactored method for not repeating code
        _showPreview(
          locData.latitude!,
          locData.longitude!,
        );

        // data need to pass into the add_place_screen to show the place
        widget.onSelectPlace(
          locData.latitude,
          locData.longitude,
        );
      } catch (error) {
        return;
      }
    }

    Future<void> _selectOnMap() async {
      final LatLng selectedLocation = await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (ctx) => MapScreen(
            isSelecting: true,
          ),
        ),
      );
      if (selectedLocation == null) {
        return;
      }

      // use the refactored method for not repeating code
      _showPreview(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );

      // method to retreive the image
      widget.onSelectPlace(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Center(
                  child: Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              color: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
