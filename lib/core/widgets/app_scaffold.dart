
import 'package:flutter/material.dart';

/// A scaffold with consistent page padding and optional app bar actions.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.actions,
    this.body,
    this.floatingActionButton,
    this.padding = const EdgeInsets.all(16),
  });

  final String? title;
  final List<Widget>? actions;
  final Widget? body;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(title: Text(title!), actions: actions),
      body: body == null ? null : Padding(padding: padding, child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
