import 'package:flutter/material.dart';
import 'package:sofi/core/l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  final Function() toLoginScreen;
  final Function() onLogoutConfirmation;
  final Function() onChangeLanguage;
  const SettingsScreen(
      {super.key,
      required this.toLoginScreen,
      required this.onLogoutConfirmation,
      required this.onChangeLanguage});

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
              onChangeLanguage();
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.logout),
            onTap: () {
              onLogoutConfirmation();
            },
          ),
        ],
      ),
    );
  }
}
