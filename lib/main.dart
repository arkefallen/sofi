import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/theme.dart';
import 'package:sofi/core/util.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/data/datasource/story_service.dart';
import 'package:sofi/presentation/provider/add_story_provider.dart';
import 'package:sofi/presentation/provider/detail_story_provider.dart';
import 'package:sofi/presentation/provider/list_story_provider.dart';
import 'package:sofi/presentation/provider/login_provider.dart';
import 'package:sofi/presentation/provider/register_provider.dart';
import 'package:sofi/presentation/screen/home_screen.dart';
import 'package:sofi/presentation/screen/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => StoryService()),
        Provider(create: (_) => SharedPreferenceService()),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(
            storyService: context.read<StoryService>(),
            sharedPreferenceService: context.read<SharedPreferenceService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RegisterProvider(storyService: context.read<StoryService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => ListStoryProvider(
            storyService: context.read<StoryService>(),
            sharedPreferenceService: context.read<SharedPreferenceService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailStoryProvider(
            storyService: context.read<StoryService>(),
            sharedPreferenceService: context.read<SharedPreferenceService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AddStoryProvider(
            storyService: context.read<StoryService>(),
            sharedPreferenceService: context.read<SharedPreferenceService>(),
          ),
        ),
      ],
      child: const SofiApp(),
    ),
  );
}

class SofiApp extends StatelessWidget {
  const SofiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Sofia Sans", "Sofia Sans");
    SofiTheme theme = SofiTheme(textTheme);

    return Consumer<SharedPreferenceService>(
      builder: (context, sharedPreferenceService, child) {
        final token = sharedPreferenceService.getToken();
        final initialScreen = (token != null && token.toString().isNotEmpty)
            ? const HomeScreen(title: "Sofi")
            : const LoginScreen();

        return MaterialApp(
          title: 'Sofi',
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          home: initialScreen,
        );
      },
    );
  }
}
