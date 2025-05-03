import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[800],
      selectedColor: const Color.fromARGB(255, 152, 56, 56),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0),
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
