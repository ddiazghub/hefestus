import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hefestus/assets.dart';
import 'package:hefestus/data/model/point.dart';
import 'package:hefestus/ui/controllers/map_controller.dart';
import 'package:hefestus/ui/controllers/user_controller.dart';
import 'package:hefestus/ui/pages/place_page.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:hefestus/ui/widgets/snapshot_builder.dart';
import 'package:hefestus/ui/widgets/spinner.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final UserController userController = Get.find();

    return HefestusPage(
      body: FutureBuilder(
        future: Assets.getIcons(),
        builder: (context, snapshot) {
          return SnapshotBuilder(
            snapshot: snapshot,
            builder: (context, icons) {
              return Center(
                child: Obx(() {
                  return controller.location == null
                      ? const Spinner()
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 350,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      controller.latitude!,
                                      controller.longitude!,
                                    ),
                                    zoom: 14.4746,
                                  ),
                                  onMapCreated: (GoogleMapController map) {
                                    final point = Point(
                                      controller.latitude!,
                                      controller.longitude!,
                                    );

                                    controller.search(point);
                                  },
                                  myLocationEnabled: true,
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('My Position'),
                                      icon: icons.user,
                                      position: controller.location!.toLatLng(),
                                      infoWindow: InfoWindow(
                                        title: 'Your position',
                                        onTap: () => print('Profile'),
                                      ),
                                    ),
                                    for (final place in controller.places)
                                      Marker(
                                          markerId: MarkerId(place.displayName),
                                          icon:
                                              userController.stores[place.id] !=
                                                      null
                                                  ? icons.hardware
                                                  : icons.hardwareGray,
                                          position: place.location.toLatLng(),
                                          infoWindow: InfoWindow(
                                            title: place.displayName,
                                            snippet: place.formattedAddress,
                                            onTap: () =>
                                                Get.to(PlacePage(place: place)),
                                          ))
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(children: [
                                for (final place in controller.places)
                                  InkWell(
                                    onTap: () => Get.to(
                                      PlacePage(place: place),
                                    ),
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                        color:
                                            userController.stores[place.id] !=
                                                    null
                                                ? theme.colorScheme.primary
                                                : Colors.grey,
                                      ),
                                      child: Center(
                                        child: Text(
                                          place.displayName,
                                          style: TextStyle(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ]),
                            ],
                          ),
                        );
                }),
              );
            },
          );
        },
      ),
    );
  }
}
