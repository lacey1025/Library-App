import 'package:flutter/material.dart';

class ScoreFieldSection extends StatelessWidget {
  final List<Widget> children;

  const ScoreFieldSection({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      color: Colors.grey[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...children],
      ),
    );
  }
}
