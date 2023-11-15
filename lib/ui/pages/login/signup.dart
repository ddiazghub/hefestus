import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/data/model/user.dart';
import 'package:hefestus/data/usecase/avatar_usecase.dart';
import 'package:hefestus/ui/controllers/auth_controller.dart';
import 'package:hefestus/ui/widgets/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpPage extends GetView<AuthController> {
  SignUpPage({super.key});

  final picker = ImagePickController();

  static const keys = (
    email: Key('EmailField'),
    submit: Key('SubmitButton'),
    password: Key('PasswordField'),
    name: Key('NameField'),
    birthday: Key('BirthdayField'),
    phone: Key('PhoneField'),
    image: Key('ImageField'),
  );

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
              final url = await AvatarUsecase.create(picker.image!);

              final String email = form.control('email').value;
              final String name = form.control('name').value;
              final String phone = form.control('phone').value;
              final DateTime birthday = form.control('birthday').value;
              final String password = form.control('password').value;

              final user = AppAuthUser(
                email,
                name,
                phone,
                birthday,
                url,
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
              Expanded(child: AppImagePicker(picker: picker)),
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
                              key: keys.name,
                              formControlName: 'name',
                              textInputAction: TextInputAction.next,
                              decoration: decoration('name'),
                            ),
                            separator,
                            ReactiveTextField<String>(
                              key: keys.email,
                              formControlName: 'email',
                              textInputAction: TextInputAction.next,
                              decoration: decoration('email'),
                            ),
                            separator,
                            ReactiveTextField<String>(
                              key: keys.password,
                              formControlName: 'password',
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              decoration: decoration('Password'),
                            ),
                            separator,
                            ReactiveDateTimePicker(
                              key: keys.birthday,
                              formControlName: 'birthday',
                              decoration: decoration(
                                'birthday',
                                icon: const Icon(Icons.calendar_today),
                              ),
                            ),
                            separator,
                            ReactiveTextField<String>(
                              key: keys.phone,
                              formControlName: 'phone',
                              textInputAction: TextInputAction.next,
                              decoration: decoration('phone'),
                            ),
                            separator,
                            ElevatedButton(
                              key: keys.submit,
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

class ImagePickController extends GetxController {
  final Rxn<XFile> _image = Rxn();

  XFile? get image => _image.value;

  set image(XFile? value) => _image.value = value;
}
