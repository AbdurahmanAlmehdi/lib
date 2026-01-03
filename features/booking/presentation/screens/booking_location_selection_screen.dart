import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';
import 'package:buzzy_bee/core/routes/app_routes.dart';
import 'package:buzzy_bee/features/booking/domain/entities/location.dart';
import 'package:buzzy_bee/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:buzzy_bee/features/booking/presentation/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart' hide TextDirection;
import 'package:flutter/material.dart' as material show TextDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingLocationSelectionScreen extends StatefulWidget {
  const BookingLocationSelectionScreen({super.key});

  @override
  State<BookingLocationSelectionScreen> createState() =>
      _BookingLocationSelectionScreenState();
}

class _BookingLocationSelectionScreenState
    extends State<BookingLocationSelectionScreen> {
  LatLng? _selectedLatLng;
  bool _isLoading = false;
  String? _errorMessage;
  GoogleMapController? _mapController;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    final state = context.read<BookingBloc>().state;
    if (state.selectedLocation != null) {
      _selectedLatLng = LatLng(
        state.selectedLocation!.latitude,
        state.selectedLocation!.longitude,
      );
      _selectedAddress = state.selectedLocation!.address;
    }
    _initLocation();
  }

  Future<void> _initLocation() async {
    if (_selectedLatLng != null) {
      // If we already have a location, just update the map
      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLatLng!, 15),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _selectedLatLng = const LatLng(32.8872, 13.1913);
      } else {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _selectedLatLng = LatLng(pos.latitude, pos.longitude);
      }

      if (_mapController != null && _selectedLatLng != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLatLng!, 15),
        );
      }
    } catch (e) {
      _selectedLatLng ??= const LatLng(32.8872, 13.1913);
      if (mounted) {
        _errorMessage = context.t.couldNotGetLocation;
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onShareCurrentLocation() {
    if (_selectedLatLng == null) {
      context.showSnackBar(context.t.pleaseSelectLocation);
      return;
    }

    setState(() {
      _selectedAddress =
          '${_selectedLatLng!.latitude.toStringAsFixed(4)}, ${_selectedLatLng!.longitude.toStringAsFixed(4)}';
    });

    final location = Location(
      id: 'selected',
      address: _selectedAddress!,
      latitude: _selectedLatLng!.latitude,
      longitude: _selectedLatLng!.longitude,
    );

    context.read<BookingBloc>().add(SelectLocation(location));
  }

  void _onContinue() {
    if (_selectedLatLng == null || _selectedAddress == null) {
      context.showSnackBar(context.t.pleaseSelectLocation);
      return;
    }

    final location = Location(
      id: 'selected',
      address: _selectedAddress!,
      latitude: _selectedLatLng!.latitude,
      longitude: _selectedLatLng!.longitude,
    );

    context.read<BookingBloc>().add(SelectLocation(location));
    context.pushNamed(AppRouteNames.phoneInput);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarWidget(title: context.t.step4),
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              context.t.selectLocation,
                              textAlign: TextAlign.center,
                              style: AppTypography.headlineSmall(context)
                                  .copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            // Instruction text
                            Text(
                              context.t.shareLocationMessage,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium(
                                context,
                              ).copyWith(color: AppColors.textSecondary),
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySmall(
                                  context,
                                ).copyWith(color: AppColors.warningDark),
                              ),
                            ],
                            const SizedBox(height: 24),
                            // Map
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: SizedBox(
                                height: 300,
                                child: _isLoading || _selectedLatLng == null
                                    ? Container(
                                        color: AppColors.surfaceVariant,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: _selectedLatLng!,
                                          zoom: 13,
                                        ),
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: true,
                                        zoomControlsEnabled: false,
                                        onMapCreated: (controller) {
                                          _mapController = controller;
                                        },
                                        onTap: (latLng) {
                                          setState(() {
                                            _selectedLatLng = latLng;
                                            _selectedAddress =
                                                '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}';
                                          });
                                        },
                                        markers: _selectedLatLng == null
                                            ? {}
                                            : {
                                                Marker(
                                                  markerId: const MarkerId(
                                                    'selected',
                                                  ),
                                                  position: _selectedLatLng!,
                                                ),
                                              },
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Share location button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.info,
                                  foregroundColor: AppColors.textOnSecondary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: _onShareCurrentLocation,
                                child: Text(
                                  context.t.shareCurrentLocation,
                                  style: AppTypography.titleMedium(
                                    context,
                                  ).copyWith(color: AppColors.textOnSecondary),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Privacy text
                            Text(
                              context.t.locationPrivacy,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySmall(
                                context,
                              ).copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Footer with address and continue button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border(
                          top: BorderSide(color: AppColors.border, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Tappable address field
                          InkWell(
                            onTap: () {
                              // When tapped, update location from map selection
                              if (_selectedLatLng != null) {
                                _onShareCurrentLocation();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.info,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                _selectedAddress ??
                                    context.t.pleaseSelectLocation,
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium(
                                  context,
                                ).copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.info,
                                foregroundColor: AppColors.textOnSecondary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed: _onContinue,
                              child: Text(
                                context.t.continueText,
                                style: AppTypography.titleLarge(context)
                                    .copyWith(
                                      color: AppColors.textOnSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
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
      ),
    );
  }
}
