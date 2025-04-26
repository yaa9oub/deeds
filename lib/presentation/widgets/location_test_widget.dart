import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/location_service.dart';

class LocationTestWidget extends StatelessWidget {
  LocationTestWidget({Key? key}) : super(key: key);

  final LocationService locationService = Get.find<LocationService>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
                  'City: ${locationService.currentCity}',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
            const SizedBox(height: 8),
            Obx(() => Text(
                  'Country: ${locationService.currentCountry}',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
            const SizedBox(height: 8),
            Obx(() {
              final position = locationService.currentPosition;
              return Text(
                position != null
                    ? 'Location: ${position.latitude}, ${position.longitude}'
                    : 'Location: Not available',
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }),
            const SizedBox(height: 16),
            Obx(() => locationService.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => locationService.getCurrentLocation(),
                    child: const Text('Refresh Location'),
                  )),
          ],
        ),
      ),
    );
  }
}
