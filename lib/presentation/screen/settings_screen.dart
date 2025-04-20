import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/data/datasource/shared_preference_service.dart';
import 'package:sofi/presentation/provider/localization_provider.dart';

class SettingsScreen extends StatelessWidget {
  final Function() toLoginScreen;
  const SettingsScreen({super.key, required this.toLoginScreen});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.changeLanguage),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(
                              l10n.selectLanguage,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: AppLocalizations.supportedLocales.map(
                              (locale) {
                                return ListTile(
                                  leading: Text(
                                    context
                                        .watch<LocalizationProvider>()
                                        .getFlag(locale.languageCode),
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                  title: locale.languageCode == 'en'
                                      ? Text(l10n.english)
                                      : Text(l10n.bahasa),
                                  onTap: () {
                                    context
                                        .read<LocalizationProvider>()
                                        .setLocale(locale);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.logout),
                  content: Text(l10n.logoutConfirmation),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        await context
                            .read<SharedPreferenceService>()
                            .removeAllData();
                        toLoginScreen();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: Text(l10n.logout),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
