import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

/// [LocationPicker] - Fullscreen map to pick coordinates.
/// Returns a `LatLng` via `Get.back(result: LatLng)` when confirmed.
class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selected = LatLng(widget.initialLatitude!, widget.initialLongitude!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = _selected ?? const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: _selected == null
                ? null
                : () {
                    Get.back(result: _selected);
                  },
            child: const Text('Confirm'),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 3,
          onTap: (tapPosition, latLng) {
            setState(() => _selected = latLng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'astro_iztro',
          ),
          if (_selected != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 40,
                  height: 40,
                  point: _selected!,
                  child: const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selected == null
                    ? 'Tap on the map to select a location'
                    : 'Lat: ${_selected!.latitude.toStringAsFixed(6)}, Lng: ${_selected!.longitude.toStringAsFixed(6)}',
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _selected == null
                    ? null
                    : () => Get.back(result: _selected),
                icon: const Icon(Icons.check),
                label: const Text('Use This Location'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
