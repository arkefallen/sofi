import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/core/theme.dart';
import 'package:sofi/core/util.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/data/datasource/story_service.dart';
import 'package:sofi/presentation/navigation/page_manager.dart';
import 'package:sofi/presentation/navigation/router_delegate.dart';
import 'package:sofi/presentation/provider/add_story_provider.dart';
import 'package:sofi/presentation/provider/detail_story_provider.dart';
import 'package:sofi/presentation/provider/list_story_provider.dart';
import 'package:sofi/presentation/provider/localization_provider.dart';
import 'package:sofi/presentation/provider/login_provider.dart';
import 'package:sofi/presentation/provider/register_provider.dart';

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
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
        ChangeNotifierProvider(create: (_) => PageManager()),
      ],
      child: const SofiApp(),
    ),
  );
}

class SofiApp extends StatefulWidget {
  const SofiApp({super.key});

  @override
  State<SofiApp> createState() => _SofiAppState();
}

class _SofiAppState extends State<SofiApp> {
  late final SofiRouterDelegate routerDelegate;

  @override
  void initState() {
    super.initState();
    routerDelegate = SofiRouterDelegate(
      context.read<SharedPreferenceService>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Sofia Sans", "Sofia Sans");
    SofiTheme theme = SofiTheme(textTheme);

    return Consumer<SharedPreferenceService>(
      builder: (context, sharedPreferenceService, child) {
        return MaterialApp(
          locale: context.watch<LocalizationProvider>().locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return supportedLocales.first;
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // theme: brightness == Brightness.light ? theme.light() : theme.dark(),

          title: 'Sofi',
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          home: Router(
            routerDelegate: routerDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        );
      },
    );
  }
}
