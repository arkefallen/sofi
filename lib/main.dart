import 'package:flutter/material.dart';
import 'package:sofi/core/theme.dart';
import 'package:sofi/core/util.dart';
import 'package:sofi/presentation/screen/home_screen.dart';

void main() {
  runApp(const SofiApp());
}

class SofiApp extends StatelessWidget {
  const SofiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Sofia Sans", "Sofia Sans");
    SofiTheme theme = SofiTheme(textTheme);
    return MaterialApp(
      title: 'Sofi',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const HomeScreen(title: 'Sofi - Social Media App'),
    );
  }
}
