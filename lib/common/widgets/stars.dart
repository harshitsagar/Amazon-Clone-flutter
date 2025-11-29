import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Stars extends StatelessWidget {
  final double rating;
  final double size;
  const Stars({super.key, required this.rating, this.size = 15});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemCount: 5,
      itemSize: size,
      direction: Axis.horizontal,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: GlobalVariables.secondaryColor,
      ),
    );
  }
}
