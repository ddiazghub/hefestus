import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hefestus/assets.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/data/model/user.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/controllers/map_controller.dart';
import 'package:hefestus/ui/controllers/place_picker_controller.dart';
import 'package:hefestus/ui/widgets/snapshot_builder.dart';
import 'package:hefestus/ui/widgets/spinner.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:reactive_forms/reactive_forms.dart';

class StoreSignUpPage extends StatefulWidget {
  const StoreSignUpPage({super.key});

  @override
  State<StoreSignUpPage> createState() => StoreSignUpPageState();
}

class StoreSignUpPageState extends State<StoreSignUpPage> {
  final controller = TextEditingController();
  final PlacePickerController picker = PlacePickerController();

  FormGroup buildForm() {
    return fb.group({
      'email': ['', Validators.required, Validators.email],
      'password': ['', Validators.required, Validators.minLength(2)],
    });
  }

  static InputDecoration decoration(String label, {Icon? icon}) {
    return InputDecoration(
      labelText: label,
      helperText: '',
      helperStyle: const TextStyle(height: 0.7),
      errorStyle: const TextStyle(height: 0.7),
      suffixIcon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    const separator = SizedBox(height: 8);
    final MapController map = Get.find();
    GoogleMapController? googleMapController;
    final AuthController auth = Get.find();
    final completion = _debounce<List<PlaceCompletion>, String>(
      (text) => map.complete(text),
      const Duration(milliseconds: 500),
    );

    return FutureBuilder(
        future: Assets.getIcons(),
        builder: (context, snapshot) {
          return SnapshotBuilder(
              snapshot: snapshot,
              builder: (context, icons) {
                return Scaffold(
                  body: ReactiveFormBuilder(
                    form: buildForm,
                    builder: (context, form, child) {
                      Future<void> signup() async {
                        if (form.valid) {
                          final String email = form.control('email').value;
                          final String password = form.control('password').value;

                          final user = StoreAuthUser(
                            email,
                            'None',
                            password,
                          );

                          await auth.signup(user);
                          Get.back();
                        } else {
                          form.markAllAsTouched();
                        }
                      }

                      final theme = Theme.of(context);

                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Autocomplete<PlaceCompletion>(
                                    displayStringForOption: (place) => place.displayName,
                                    optionsBuilder: (value) async {
                                      try {
                                        final List<PlaceCompletion>? options = await completion(value.text);
                                        if (options == null) {
                                          return [];
                                        }

                                        return options;
                                      } catch (err) {
                                        return [];
                                      }
                                    },
                                    optionsViewBuilder: (context, onSelected, options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(maxHeight: 500),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                for (final (index, place) in options.indexed)
                                                  Builder(builder: (BuildContext context) {
                                                    final bool highlight =
                                                        AutocompleteHighlightedOption.of(context) == index;
                                                    if (highlight) {
                                                      SchedulerBinding.instance
                                                          .addPostFrameCallback((Duration timeStamp) {
                                                        Scrollable.ensureVisible(context, alignment: 0.5);
                                                      });
                                                    }
                                                    return ListTile(
                                                      tileColor: highlight ? Theme.of(context).focusColor : null,
                                                      onTap: () {
                                                        onSelected(place);
                                                        print('Tapped item: ${place.displayName}');
                                                        controller.text = place.displayName;
                                                        picker.selected.value = place;
                                                        googleMapController?.moveCamera(
                                                          CameraUpdate.newLatLngZoom(
                                                            place.location.toLatLng(),
                                                            14.4746,
                                                          ),
                                                        );
                                                      },
                                                      leading: const Icon(Icons.location_pin),
                                                      title: Text(place.displayName),
                                                      subtitle: Text(place.formattedAddress),
                                                    );
                                                  }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 500,
                                    child: Obx(() {
                                      return map.location == null
                                          ? const Spinner()
                                          : PointerInterceptor(
                                              child: GoogleMap(
                                                zoomControlsEnabled: false,
                                                zoomGesturesEnabled: false,
                                                tiltGesturesEnabled: false,
                                                rotateGesturesEnabled: false,
                                                scrollGesturesEnabled: false,
                                                mapType: MapType.normal,
                                                onMapCreated: (controller) => googleMapController = controller,
                                                initialCameraPosition: CameraPosition(
                                                  target: LatLng(
                                                    map.latitude!,
                                                    map.longitude!,
                                                  ),
                                                  zoom: 14.4746,
                                                ),
                                                myLocationEnabled: true,
                                                markers: {
                                                  if (picker.selected.value != null)
                                                    Marker(
                                                      markerId: const MarkerId('My Position'),
                                                      icon: icons.hardware,
                                                      position: picker.selected.value!.location.toLatLng(),
                                                      infoWindow: InfoWindow(
                                                        title: picker.selected.value!.displayName,
                                                        snippet: picker.selected.value!.formattedAddress,
                                                      ),
                                                    ),
                                                },
                                              ),
                                            );
                                    }),
                                  ),
                                  // AsyncAutocomplete<PlaceCompletion>(
                                  //   decoration: InputDecoration(
                                  //     hintText: 'Select your store',
                                  //     border: OutlineInputBorder(
                                  //       borderSide: BorderSide(color: theme.colorScheme.secondary),
                                  //     ),
                                  //   ),
                                  //   controller: controller,
                                  //   maxListHeight: 500,
                                  //   asyncSuggestions: (text) async {
                                  //     if (text.isEmpty) {
                                  //       return [];
                                  //     } else {
                                  //       return map.complete(text);
                                  //     }
                                  //   },
                                  //   suggestionBuilder: (place) {
                                  //     return ListTile(
                                  //       onTap: () {
                                  //         print('Tapped item: ${place.displayName}');
                                  //         controller.text = place.displayName;
                                  //         picker.selected.value = place;
                                  //         googleMapController?.moveCamera(
                                  //           CameraUpdate.newLatLngZoom(
                                  //             place.location.toLatLng(),
                                  //             14.4746,
                                  //           ),
                                  //         );
                                  //       },
                                  //       leading: const Icon(Icons.location_pin),
                                  //       title: Text(place.displayName),
                                  //       subtitle: Text(place.formattedAddress),
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 500),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ReactiveTextField<String>(
                                          formControlName: 'email',
                                          textInputAction: TextInputAction.next,
                                          decoration: decoration('email'),
                                        ),
                                        separator,
                                        ReactiveTextField<String>(
                                          formControlName: 'password',
                                          obscureText: true,
                                          textInputAction: TextInputAction.next,
                                          decoration: decoration('Password'),
                                        ),
                                        separator,
                                        ElevatedButton(
                                          onPressed: signup,
                                          child: const Text('Submit'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              });
        });
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function, Duration duration) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer(duration);
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer(Duration duration) {
    _timer = Timer(duration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}
