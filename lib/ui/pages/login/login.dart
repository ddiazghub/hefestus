import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hefestus/ui/pages/login/signup.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  static final defaultUsers = [
    ('a@a.com', '123456'),
    ('b@b.com', '123456'),
    ('c@c.com', '123456'),
  ];

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
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    ElevatedButton(
                      onPressed: () async {
                        if (form.valid) {
                          final String email = form.control('email').value;
                          final String password = form.control('password').value;

                          await controller.login(email, password);
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () => Get.to(SignUpPage()),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Create user account'),
                        ),
                        const SizedBox(width: 40.0),
                        TextButton.icon(
                          onPressed: () => Get.to(SignUpPage()),
                          icon: const Icon(Icons.hardware),
                          label: const Text('Create store account'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
