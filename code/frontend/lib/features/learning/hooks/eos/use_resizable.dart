import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/features/learning/widgets/eos/vertial_splitter.dart';

// Hook trả về một Record (width, splitter)
(double, Widget) useEosResizable({
  double initialWidth = 120.0,
  double minWidth = 50.0,
  double maxWidth = 400.0,
}) {
  final widthNotifier = useState(initialWidth);

  final splitter = EosVerticalSplitter(
    widthNotifier: widthNotifier,
    minWidth: minWidth,
    maxWidth: maxWidth,
  );

  // Trả về Record
  return (widthNotifier.value, splitter);
}
