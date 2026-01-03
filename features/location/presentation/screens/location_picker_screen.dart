import 'package:buzzy_bee/core/theme/app_colors.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/features/booking/domain/entities/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _selectedLatLng;
  bool _isLoading = false;
  String? _errorMessage;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
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
        // Fallback default city (Tripoli) if permission denied
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
      _errorMessage = 'تعذر الحصول على موقعك، استخدم الخريطة لاختيار المكان.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onConfirmLocation() {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختَر موقعاً من الخريطة أولاً')),
      );
      return;
    }

    final location = Location(
      id: 'selected',
      address:
          'الموقع المحدد (${_selectedLatLng!.latitude.toStringAsFixed(4)}, ${_selectedLatLng!.longitude.toStringAsFixed(4)})',
      latitude: _selectedLatLng!.latitude,
      longitude: _selectedLatLng!.longitude,
    );

    Navigator.of(context).pop(location);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          title: Text(
            'وين نجّو نخدموك؟',
            style: AppTypography.headlineSmall(
              context,
            ).copyWith(color: AppColors.textOnPrimary),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                'شاركنا موقعك باش نوصلك في الوقت الصح 🚗✨',
                textAlign: TextAlign.center,
                style: AppTypography.headlineSmall(
                  context,
                ).copyWith(color: AppColors.textPrimary),
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
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: _isLoading || _selectedLatLng == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _selectedLatLng!,
                            zoom: 15,
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
                            });
                          },
                          markers: {
                            Marker(
                              markerId: const MarkerId('selected'),
                              position: _selectedLatLng!,
                            ),
                          },
                        ),
                ),
              ),
              const SizedBox(height: 24),
              _ShareLocationButton(onPressed: _onConfirmLocation),
              const SizedBox(height: 12),
              Text(
                'موقعك يُستخدم فقط لتحديد مكان الخدمة ولن يتم مشاركته مع أي جهة أخرى.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall(
                  context,
                ).copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ShareLocationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.info,
          foregroundColor: AppColors.textOnSecondary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          'شارك موقعك الحالي',
          style: AppTypography.titleMedium(
            context,
          ).copyWith(color: AppColors.textOnSecondary),
        ),
      ),
    );
  }
}
