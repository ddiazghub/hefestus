import 'package:hefestus/ui/central.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final validation = {
    ValidationMessage.required: (_) => 'Field is mandatory',
    ValidationMessage.email: (_) => 'Must enter a valid email',
    ValidationMessage.minLength: (error) =>
        'Field must have a minimum length of ${(error as Map)['requiredLength']}',
    ValidationMessage.number: (_) => 'Field must be a number',
    'uniqueEmail': (_) => 'This email is already in use',
    'url': (_) => 'Field must be an URL',
    'dateRange': (_) =>
        'Invalid date range. Start time must be beform end time',
  };

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: validation,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hefestus',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Central(),
      ),
    );
  }
}
