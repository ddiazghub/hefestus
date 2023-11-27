import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/assets.dart';
import 'package:hefestus/ui/pages/login/signup.dart';
import 'package:hefestus/ui/pages/login/store_signup.dart';
import 'package:hefestus/ui/widgets/hefestus_page.dart';
import 'package:hefestus/ui/widgets/submit_button.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  static InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      helperText: '',
      helperStyle: const TextStyle(height: 0.7),
      errorStyle: const TextStyle(height: 0.7),
    );
  }

  FormGroup buildForm() {
    return fb.group({
      'email': ['', Validators.required, Validators.email],
      'password': ['', Validators.required, Validators.minLength(2)],
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final buttons = [
      TextButton.icon(
        onPressed: () => Get.to(SignUpPage()),
        icon: const Icon(Icons.person_add),
        label: const Text('Create user account'),
      ),
      size.width < 600
          ? const SizedBox(height: 10)
          : const SizedBox(width: 40.0),
      TextButton.icon(
        onPressed: () => Get.to(StoreSignUpPage()),
        icon: const Icon(Icons.hardware),
        label: const Text('Create store account'),
      ),
    ];

    return HefestusPage(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                return SingleChildScrollView(
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
                      const SizedBox(height: 16.0),
                      ReactiveTextField<String>(
                        formControlName: 'password',
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: decoration('Password'),
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      SubmitButton(onPressed: () async {
                        if (form.valid) {
                          final String email = form.control('email').value;
                          final String password =
                              form.control('password').value;

                          await controller.login(email, password);
                        } else {
                          form.markAllAsTouched();
                        }
                      }),
                      const SizedBox(height: 24.0),
                      size.width < 600
                          ? Column(children: buttons)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: buttons,
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
