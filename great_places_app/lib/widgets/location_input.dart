import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../helpers/location_helpers.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override
  Widget build(BuildContext context) {
    late String _previewImageUrl;

    Future<void> _getCurrentUserLocation() async {
      final locData = await Location().getLocation();
      final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locData.latitude,
        longitude: locData.longitude,
      );
      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });
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
              onPressed: () {},
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              color: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select in Map'),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
