import 'package:flutter/material.dart';
import 'package:library_app/models/score_with_details.dart';
import 'package:library_app/screens/view_score/view_score.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, required this.score});

  final ScoreWithDetails score;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (score.status != null)
              Icon(score.status!.icon, color: score.status!.color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.score.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (score.composer != null)
                    Text(
                      score.composer!.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (score.category != null)
                    Text(
                      '${score.category!.identifier} ${score.score.catalogNumber.toString().padLeft(4, '0')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            SizedBox(width: 5),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ViewScore(score.score.id),
                  ),
                );
              },
              icon: Icon(Icons.arrow_forward, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
