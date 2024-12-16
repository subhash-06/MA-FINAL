import 'package:flutter/material.dart';
import '../models/foursquare_categories.dart'; // Adjust the import path as necessary

class CategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: FoursquareCategories.values.length,
        itemBuilder: (context, index) {
          final category = FoursquareCategories.values[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ActionChip(
              label: Text(category.name),
              onPressed: () {
                // Here, you might want to do something like update a state manager or call a function.
                print("Selected Category: ${category.name}");
              },
            ),
          );
        },
      ),
    );
  }
}
