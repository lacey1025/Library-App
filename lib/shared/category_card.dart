import 'package:flutter/material.dart';
import 'package:library_app/database/library_database.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.selected,
  });

  final CategoryData category;
  final void Function(CategoryData) onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(category);
      },
      child: Card(
        color:
            selected ? Colors.grey[700] : const Color.fromARGB(255, 40, 40, 40),
        margin: EdgeInsets.only(bottom: 6),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: [
              Text(
                category.name,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: selected ? Colors.white : Colors.grey[500],
                ),
              ),
              Expanded(child: SizedBox()),
              Icon(
                Icons.check,
                color: selected ? Colors.red[400] : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
