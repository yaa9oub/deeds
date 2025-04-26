import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final RxString _currentCity = RxString('');
  final RxString _currentCountry = RxString('');
  final RxBool _isLoading = RxBool(false);

  Position? get currentPosition => _currentPosition.value;
  String get currentCity => _currentCity.value;
  String get currentCountry => _currentCountry.value;
  bool get isLoading => _isLoading.value;

  Future<LocationService> init() async {
    await getCurrentLocation();
    return this;
  }

  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services to use this feature.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permissions are denied.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Location permissions are permanently denied, we cannot request permissions.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  String _getValidCityName(Placemark place) {
    // Try different fields in order of preference
    if (place.locality != null && place.locality!.isNotEmpty) {
      return place.locality!;
    }
    if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      return place.subAdministrativeArea!;
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      return place.administrativeArea!;
    }
    return 'Unknown City';
  }

  Future<void> _updateLocationDetails(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'en' // Force English locale
          );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print('Placemark details: ${place.toJson()}'); // Debug print

        // Update city using the helper method
        _currentCity.value = _getValidCityName(place);

        // Update country, fallback to isoCountryCode if country is empty
        _currentCountry.value = place.country?.isNotEmpty == true
            ? place.country!
            : place.isoCountryCode ?? 'Unknown Country';

        print(
            'Updated location - City: ${_currentCity.value}, Country: ${_currentCountry.value}');
      } else {
        print(
            'No placemarks found for location: ${position.latitude}, ${position.longitude}');
        _currentCity.value = 'Unknown City';
        _currentCountry.value = 'Unknown Country';
      }
    } catch (e) {
      print('Error in _updateLocationDetails: $e');
      _currentCity.value = 'Error getting city';
      _currentCountry.value = 'Error getting country';
      rethrow;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      _isLoading.value = true;

      bool hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        _isLoading.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print(
          'Got position - Lat: ${position.latitude}, Lng: ${position.longitude}');
      _currentPosition.value = position;

      await _updateLocationDetails(position);
    } catch (e) {
      print('Error in getCurrentLocation: $e');
      Get.snackbar(
        'Error',
        'Failed to get location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> startLocationUpdates() async {
    bool hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return;

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Update every 100 meters
      ),
    ).listen(
      (Position position) async {
        print(
            'Location update - Lat: ${position.latitude}, Lng: ${position.longitude}');
        _currentPosition.value = position;
        await _updateLocationDetails(position);
      },
      onError: (error) {
        print('Error in location stream: $error');
        Get.snackbar(
          'Error',
          'Location update error: ${error.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}

extension PlacemarkExtension on Placemark {
  Map<String, dynamic> toJson() => {
        'name': name,
        'locality': locality,
        'subLocality': subLocality,
        'subAdministrativeArea': subAdministrativeArea,
        'administrativeArea': administrativeArea,
        'country': country,
        'isoCountryCode': isoCountryCode,
        'postalCode': postalCode,
        'thoroughfare': thoroughfare,
        'subThoroughfare': subThoroughfare,
      };
}
