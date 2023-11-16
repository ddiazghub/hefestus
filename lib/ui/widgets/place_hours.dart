import 'package:flutter/material.dart';
import 'package:hefestus/data/model/place.dart';

class PlaceHours extends StatelessWidget {
  const PlaceHours({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    if (place.currentOpeningHours == null) {
      return const SizedBox();
    }

    final theme = Theme.of(context);

    return ExpansionTile(
      title: Row(
        children: [
          Icon(
            Icons.timer_rounded,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              place.currentOpeningHours!.openNow
                  ? const Text(
                      'Currently open',
                      style: TextStyle(color: Colors.green),
                    )
                  : const Text(
                      'Currently closed',
                      style: TextStyle(color: Colors.red),
                    ),
              const Text('Click to see business schedules',
                  style: TextStyle(fontSize: 10),),
            ],
          ),
        ],
      ),
      children: [
        for (final day in place.currentOpeningHours!.weekdayDescriptions)
          ListTile(
            title: Text(
              day,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
      ],
    );
  }
}
