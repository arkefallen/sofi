import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/presentation/provider/add_story_provider.dart';
import 'package:sofi/presentation/provider/maps_provider.dart';

class MapsScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final Function() onLocationFinalized;

  const MapsScreen(
      {super.key, this.initialLocation, required this.onLocationFinalized});

  @override
  MapsScreenState createState() => MapsScreenState();
}

class MapsScreenState extends State<MapsScreen> {
  late MapsProvider _mapsProvider;
  late AddStoryProvider _addStoryProvider;

  @override
  void initState() {
    super.initState();
    _mapsProvider = context.read<MapsProvider>();
    _addStoryProvider = context.read<AddStoryProvider>();
    Future.microtask(() {
      _checkLocationPermissionAndGps();
    });
  }

  @override
  void dispose() {
    _addStoryProvider.mapController = null;
    _mapsProvider.isLoading = true;
    super.dispose();
  }

  Future<void> _checkLocationPermissionAndGps() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      LocationData locationData = await location.getLocation();
      _mapsProvider.isGpsEnabled = true;
      _mapsProvider.isLocationPermissionGranted = true;
      _mapsProvider.isLoading = false;
      _mapsProvider.currentLocation ??= widget.initialLocation ??
          LatLng(locationData.latitude!, locationData.longitude!);
    } else {
      _mapsProvider.isGpsEnabled = false;
      _mapsProvider.isLocationPermissionGranted = false;
      _mapsProvider.isLoading = false;
    }
  }

  void _onMapTap(LatLng position) {
    _mapsProvider.updateSelectedPosition(position);
    setState(() {});
    final GoogleMapController mapController = _addStoryProvider.mapController!;
    mapController.animateCamera(CameraUpdate.newLatLng(position));
    mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  void _finalizePosition() {
    if (_mapsProvider.selectedPosition != null) {
      _mapsProvider.finalizeSelectedPosition();
      _addStoryProvider.setLocation(_mapsProvider.currentLocation!.latitude,
          _mapsProvider.currentLocation!.longitude);
      widget.onLocationFinalized();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location on the map.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectLocation),
      ),
      body: context.watch<MapsProvider>().isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : !context.watch<MapsProvider>().isGpsEnabled ||
                  !context.watch<MapsProvider>().isLocationPermissionGranted
              ? Center(
                  child: Text(
                    l10n.allowLocationSuggestion,
                    textAlign: TextAlign.center,
                  ),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _mapsProvider.currentLocation != null
                            ? _mapsProvider.currentLocation!
                            : const LatLng(37.7749, -122.4194),
                        zoom: 12,
                      ),
                      onMapCreated: (controller) {
                        _addStoryProvider.mapController = controller;
                        _mapsProvider.isLoading = false;
                      },
                      onTap: (LatLng position) {
                        _onMapTap(position);
                      },
                      markers: _mapsProvider.selectedPosition != null
                          ? {
                              if (_mapsProvider.selectedPosition != null)
                                Marker(
                                  markerId: const MarkerId('selected-location'),
                                  position: _mapsProvider.selectedPosition!,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRed),
                                  infoWindow: InfoWindow(
                                    title: l10n.selectedLocationTitle,
                                    snippet: l10n.selectedLocationDescription,
                                  ),
                                ),
                              if (_mapsProvider.currentLocation != null)
                                Marker(
                                  markerId: const MarkerId('current-location'),
                                  position: context
                                      .watch<MapsProvider>()
                                      .currentLocation!,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue),
                                  infoWindow: const InfoWindow(
                                    title: 'Current Location',
                                    snippet: 'This is your current location',
                                  ),
                                ),
                            }
                          : {},
                    ),
                    if (_mapsProvider.selectedPosition != null)
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: _finalizePosition,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                'Select Location',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                _mapsProvider.resetSelectedPosition();
                                _addStoryProvider.resetLocation();
                              },
                              label: const Text('Remove Location'),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }
}
