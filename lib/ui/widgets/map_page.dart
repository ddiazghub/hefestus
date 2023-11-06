import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hefestus/data/model/point.dart';
import 'package:hefestus/ui/controllers/map_controller.dart';
import 'package:hefestus/ui/widgets/spinner.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Obx(() {
        return controller.location == null
            ? const Spinner()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Latitude: ${controller.latitude}'),
                    Text('Longitude: ${controller.longitude}'),
                    SizedBox(
                      height: 400,
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(children: [
                      for (final place in controller.places)
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: theme.colorScheme.primary,
                          ),
                          child: Center(
                            child: Text(place.displayName),
                          ),
                        )
                    ]),
                  ],
                ),
              );
      }),
    );
  }
}

// class _MapPageState extends StatelessWidget {
//   // @override
//   // void initState() {
//   //   firestoreController.suscribeUpdates();
//   //   super.initState();
//   // }
//
//   // @override
//   // void dispose() {
//   //   firestoreController.suscribeUpdates();
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Text('Hello');
//     return Scaffold(
//         body: Obx(
//           () => ListView.builder(
//               itemCount: 0,
//               padding: const EdgeInsets.only(top: 20.0),
//               itemBuilder: (BuildContext context, int index) {
//
//                 // return _buildItem(context, firestoreController.entries[index]);
//               }),
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add),
//           onPressed: () {
//             // addBaby(context);
//           },
//         ));
//   }
//
//   // Widget _buildItem(BuildContext context, Record record) {
//   //   return Padding(
//   //     key: ValueKey(record.name),
//   //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//   //     child: Container(
//   //       decoration: BoxDecoration(
//   //         border: Border.all(color: Colors.grey),
//   //         borderRadius: BorderRadius.circular(5.0),
//   //       ),
//   //       child: ListTile(
//   //         title: Text(record.name),
//   //         trailing: Text(record.votes.toString()),
//   //         onTap: () => firestoreController.updateEntry(record),
//   //         onLongPress: () => firestoreController.deleteEntry(record),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // Future<void> addBaby(BuildContext context) async {
//   //   getName(context).then((value) {
//   //     firestoreController.addEntry(value);
//   //   });
//   // }
//
//   // Future<String> getName(BuildContext context) async {
//   //   String? result = await prompt(
//   //     context,
//   //     title: const Text('Adding a baby'),
//   //     initialValue: '',
//   //     textOK: const Text('Ok'),
//   //     textCancel: const Text('Cancel'),
//   //     hintText: 'Baby name',
//   //     minLines: 1,
//   //     autoFocus: true,
//   //     obscureText: false,
//   //     textCapitalization: TextCapitalization.words,
//   //   );
//   //   if (result != null) {
//   //     return Future.value(result);
//   //   }
//   //   return Future.error('cancel');
//   // }
// }
