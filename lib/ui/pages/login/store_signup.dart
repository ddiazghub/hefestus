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
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:hefestus/ui/widgets/snapshot_builder.dart';
import 'package:hefestus/ui/widgets/spinner.dart';
import 'package:hefestus/ui/widgets/submit_button.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:reactive_forms/reactive_forms.dart';

class StoreSignUpPage extends StatelessWidget {
  StoreSignUpPage({super.key});

  final picker = PlacePickerController();

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
    final AuthController auth = Get.find();
    final row = MediaQuery.of(context).size.width > 800;

    return HefestusPage(
      body: Scaffold(
        body: ReactiveFormBuilder(
          form: buildForm,
          builder: (context, form, child) {
            Future<void> signup() async {
              if (picker.selected.value == null) {
                Get.snackbar('Error', 'Please select a hardware store');
                return;
              }

              if (form.valid) {
                final String email = form.control('email').value;
                final String password = form.control('password').value;

                final store = StoreAuthUser(
                  email,
                  picker.selected.value!.id,
                  password,
                );

                await auth.signup(store, false);
                Get.back();
              } else {
                form.markAllAsTouched();
              }
            }

            final signupForm = Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.logo),
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
                        if (!row) ...[
                          PlacePicker(picker: picker),
                          separator,
                        ],
                        SubmitButton(onPressed: signup),
                      ],
                    ),
                  ),
                ),
              ),
            );

            if (row) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: PlacePicker(picker: picker),
                    ),
                  ),
                  Expanded(child: signupForm),
                ],
              );
            } else {
              return signupForm;
            }
          },
        ),
      ),
    );
  }
}

class PlacePicker extends StatelessWidget {
  const PlacePicker({super.key, required this.picker});

  final PlacePickerController picker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MapController map = Get.find();
    GoogleMapController? googleMapController;

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
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Autocomplete<PlaceCompletion>(
                        displayStringForOption: (place) => place.displayName,
                        fieldViewBuilder: (context, textEditingController,
                            focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onSubmitted: (text) => onFieldSubmitted(),
                            decoration: InputDecoration(
                              hintText: 'Select your store',
                              focusColor: theme.colorScheme.background,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: theme.colorScheme.secondary),
                              ),
                            ),
                          );
                        },
                        optionsBuilder: (value) async {
                          try {
                            final List<PlaceCompletion>? options =
                                await completion(value.text);
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
                                constraints:
                                    const BoxConstraints(maxHeight: 500),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    for (final (index, place)
                                        in options.indexed)
                                      Builder(builder: (BuildContext context) {
                                        final bool highlight =
                                            AutocompleteHighlightedOption.of(
                                                    context) ==
                                                index;
                                        if (highlight) {
                                          SchedulerBinding.instance
                                              .addPostFrameCallback(
                                                  (Duration timeStamp) {
                                            Scrollable.ensureVisible(context,
                                                alignment: 0.5);
                                          });
                                        }
                                        return ListTile(
                                          tileColor: highlight
                                              ? Theme.of(context).focusColor
                                              : null,
                                          onTap: () {
                                            onSelected(place);
                                            picker.selected.value = place;
                                            googleMapController?.moveCamera(
                                              CameraUpdate.newLatLngZoom(
                                                place.location.toLatLng(),
                                                14.4746,
                                              ),
                                            );
                                          },
                                          leading:
                                              const Icon(Icons.location_pin),
                                          title: Text(place.displayName),
                                          subtitle:
                                              Text(place.formattedAddress),
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
                                    onMapCreated: (controller) =>
                                        googleMapController = controller,
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
                                          markerId:
                                              const MarkerId('My Position'),
                                          icon: icons.hardware,
                                          position: picker
                                              .selected.value!.location
                                              .toLatLng(),
                                          infoWindow: InfoWindow(
                                            title: picker
                                                .selected.value!.displayName,
                                            snippet: picker.selected.value!
                                                .formattedAddress,
                                          ),
                                        ),
                                    },
                                  ),
                                );
                        }),
                      ),
                    ],
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
_Debounceable<S, T> _debounce<S, T>(
    _Debounceable<S?, T> function, Duration duration) {
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
