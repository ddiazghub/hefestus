import 'package:flutter/material.dart';
import 'package:hefestus/data/model/place.dart';

class Rating extends StatelessWidget {
  const Rating({super.key, required this.place, this.color = Colors.white});

  final Place place;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final rating = place.rating ?? 0;

    final count = switch (place.userRatingCount) {
      null || 0 => 'No ratings',
      1 => '1 rating',
      (int count) => '$count ratings',
    };

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      alignment: Alignment.topLeft,
      height: 18,
      child: Row(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (rating > index && rating < index + 1) {
                return const Icon(
                  Icons.star_half,
                  color: Colors.yellow,
                  size: 16,
                );
              } else if (index < rating) {
                return const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 16,
                );
              }

              return const Icon(
                Icons.star_border,
                color: Colors.yellow,
                size: 16,
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            '$rating',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '-',
            style: TextStyle(
              color: color.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count,
            style: TextStyle(
              color: color.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
