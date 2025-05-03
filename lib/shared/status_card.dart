import 'package:flutter/material.dart';
import 'package:library_app/models/status.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.status,
    required this.onTap,
    required this.selected,
  });

  final Status status;
  final void Function(Status) onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(status);
      },
      child: Card(
        color: selected ? Colors.grey[700] : Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: [
              Icon(
                status.icon,
                color:
                    selected
                        ? status.color
                        : status.color?.withValues(alpha: 150),
              ),
              SizedBox(width: 10),
              Text(
                status.title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: selected ? Colors.white : Colors.grey[500],
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
