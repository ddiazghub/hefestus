import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/config.dart';
import 'package:hefestus/data/model/user.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:loggy/loggy.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class StoreSignUpPage extends GetView<AuthController> {
  StoreSignUpPage({super.key});

  final selection = PlaceSelectionController();

  FormGroup buildForm() {
    return fb.group({
      'email': ['', Validators.required, Validators.email],
      'password': ['', Validators.required, Validators.minLength(2)],
      'name': ['', Validators.required],
      'birthday': FormControl<DateTime>(validators: [
        Validators.required,
        Validators.max(DateTime.now()),
      ]),
      'phone': ['', Validators.required],
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

    return Scaffold(
      body: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          Future<void> signup() async {
            if (form.valid) {
              logInfo(form.value);
              // final avatar = Get.find<AvatarService>();
              // final url = await avatar.create(image.value!);

              final String email = form.control('email').value;
              final String name = form.control('name').value;
              final String phone = form.control('phone').value;
              final DateTime birthday = form.control('birthday').value;
              final String password = form.control('password').value;

              final user = StoreAuthUser(
                email,
                'None',
                password,
              );

              await controller.signup(user);
              Get.back();
            } else {
              form.markAllAsTouched();
            }
          }

          return Row(
            children: [
              // Expanded(child: AppImagePicker(picker: picker)),
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
                            OutlinedButton(
                              child: Text('show dialog'.toUpperCase()),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Example'),
                                      content: PlacesAutocomplete(
                                        apiKey: apiKey,
                                        searchHintText: 'Search for a place',
                                        mounted: true,
                                        hideBackButton: true,
                                        onSuggestionSelected: (value) =>
                                            selection.selected = value,
                                        onGetDetailsByPlaceId: (value) {
                                          print('Getting details');
                                        },
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Done'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            ReactiveTextField<String>(
                              formControlName: 'name',
                              textInputAction: TextInputAction.next,
                              decoration: decoration('name'),
                            ),
                            separator,
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
                            ReactiveDateTimePicker(
                              formControlName: 'birthday',
                              decoration: decoration(
                                'birthday',
                                icon: const Icon(Icons.calendar_today),
                              ),
                            ),
                            separator,
                            ReactiveTextField<String>(
                              formControlName: 'phone',
                              textInputAction: TextInputAction.next,
                              decoration: decoration('phone'),
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
  }
}

class PlaceSelectionController extends GetxController {
  final Rxn<Prediction> _selected = Rxn();

  Prediction? get selected => _selected.value;

  set selected(Prediction? value) => _selected.value = value;
}
