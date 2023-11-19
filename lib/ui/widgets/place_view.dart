import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hefestus/data/model/place.dart';
import 'package:hefestus/ui/widgets/place_hours.dart';
import 'package:hefestus/ui/widgets/rating.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceView extends StatelessWidget {
  const PlaceView({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(place.displayName, style: theme.textTheme.displayMedium),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(
              Icons.location_pin,
              size: 14,
            ),
            const SizedBox(width: 12),
            Text(
              place.formattedAddress,
              maxLines: 4,
              overflow: TextOverflow.fade,
              style: theme.textTheme.bodySmall,
            )
          ]),
          const SizedBox(height: 8),
          Row(
            children: [
              Rating(place: place, color: Colors.black),
              const SizedBox(width: 32),
              switch (place.businessStatus) {
                null => Text(
                    'Status unknown',
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                BusinessStatus.operational => const Text(
                    'Operational',
                    style: TextStyle(color: Colors.green),
                  ),
                BusinessStatus.closedTemporarily => const Text(
                    'Closed temporarily',
                    style: TextStyle(color: Colors.red),
                  ),
                BusinessStatus.closedPermanently => const Text(
                    'Closed permanently',
                    style: TextStyle(color: Colors.red),
                  ),
              },
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.phone,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(place.nationalPhoneNumber ?? 'Unknow phone number'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.language,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              place.websiteUri != null
                  ? RichText(
                      text: TextSpan(
                        text: place.websiteUri.toString(),
                        recognizer: TapGestureRecognizer()..onTap = () => launchUrl(place.websiteUri!),
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : const Text('No website'),
            ],
          ),
          const SizedBox(height: 8),
          PlaceHours(place: place),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'PlayFair',
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Contact',
                style: theme.textTheme.displaySmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}
