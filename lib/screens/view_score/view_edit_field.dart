import 'package:flutter/material.dart';

class ViewEditField extends StatelessWidget {
  const ViewEditField({
    super.key,
    required this.title,
    required this.item,
    required this.handleSubmit,
    required this.edit,
  });

  final String title;
  final Object item;
  final String edit;
  final void Function() handleSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                // style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                softWrap: true,
              ),
              item is String
                  ? Text(
                    item as String,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(fontSize: 20),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  )
                  : item as Widget,
            ],
          ),
        ),
        if (edit == "Done")
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: handleSubmit,
          ),
      ],
    );
  }
}
