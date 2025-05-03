import 'package:flutter/material.dart';

enum Status {
  inLibrary(
    title: "in library",
    icon: Icons.check,
    color: Color.fromRGBO(102, 187, 106, 1),
  ),
  inBinder(
    title: "in binders",
    icon: Icons.book_outlined,
    color: Color.fromRGBO(189, 189, 189, 1),
  ),
  incomplete(
    title: "incomplete",
    icon: Icons.incomplete_circle,
    color: Color.fromRGBO(239, 83, 80, 1),
  ),
  missing(
    title: "missing",
    icon: Icons.close,
    color: Color.fromRGBO(239, 83, 80, 1),
  ),
  digitalOnly(
    title: "digital only",
    icon: Icons.cloud_outlined,
    color: Color.fromRGBO(189, 189, 189, 1),
  ),
  checkedOut(
    title: "checked out",
    icon: Icons.output,
    color: Color.fromRGBO(189, 189, 189, 1),
  );

  const Status({required this.title, required this.icon, required this.color});

  final String title;
  final IconData icon;
  final Color? color;
}

extension StatusExtension on Status {
  static Status? fromTitle(String title) {
    for (final status in Status.values) {
      if (status.title == title) return status;
    }
    return null;
  }
}
