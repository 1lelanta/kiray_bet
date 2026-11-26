import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Placeholder. Lemmi replaces this with the real provider backed by settings.
final themeModeProvider = Provider<ThemeMode>(
  (ref) => ThemeMode.system,
);