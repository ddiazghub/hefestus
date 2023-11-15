import 'package:flutter/material.dart';
import 'package:hefestus/ui/widgets/rating.dart';

class PlaceView extends StatelessWidget {
  const PlaceView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          Text('Mount Fuji', style: theme.textTheme.displayMedium),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(
              Icons.location_pin,
              size: 14,
            ),
            const SizedBox(width: 12),
            Text(
              'Honshu, Japan',
              style: theme.textTheme.bodySmall,
            )
          ]),
          const SizedBox(height: 8),
          const Rating(rating: 4.5, color: Colors.black),
          const SizedBox(height: 18),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove,
                  color: theme.colorScheme.secondary,
                ),
                splashColor: theme.colorScheme.secondary,
                onPressed: () => print('Removing'),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '0',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => print('Adding'),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.timer_rounded,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                '5 Days',
                style: theme.textTheme.bodySmall!.merge(
                  TextStyle(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Description',
            style: theme.textTheme.displaySmall!.merge(
              const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enjoy your winter vacation with warmth and amazing sightseeing on the mountains. Enjoy the best experience with us!',
            maxLines: 4,
            overflow: TextOverflow.fade,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '\$400',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/Package',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
              ),
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
                    'Book Now',
                    style: theme.textTheme.displaySmall,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
