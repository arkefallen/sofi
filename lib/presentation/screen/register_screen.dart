import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/core/navigation/page_manager.dart';
import 'package:sofi/presentation/provider/register_provider.dart';
import 'package:sofi/presentation/state/register_state.dart';

class RegisterScreen extends StatefulWidget {
  final Function() toLoginScreen;

  const RegisterScreen({super.key, required this.toLoginScreen});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcome,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 54,
                  ),
            ),
            Text(
              'Sofies!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 54,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Text(
              l10n.registerScreenSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              controller: _nameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: context.watch<RegisterProvider>().isPasswordFormObscured,
              decoration: InputDecoration(
                labelText: l10n.password,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () => context.read<RegisterProvider>().setPasswordFormObscured(!context.read<RegisterProvider>().isPasswordFormObscured),
                    icon: context.watch<RegisterProvider>().isPasswordFormObscured
                        ? Icon(
                            Icons.visibility_off,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : Icon(
                            Icons.visibility,
                            color: Theme.of(context).colorScheme.secondary,
                          )),
              ),
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                performRegistration(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Consumer<RegisterProvider>(
                builder: (context, registerProvider, child) {
                  if (registerProvider.state is RegisterLoading) {
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        strokeWidth: 2.0,
                      ),
                    );
                  }
                  return Text(
                    l10n.register,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  );
                },
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.haveAccount,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      widget.toLoginScreen();
                    },
                    child: Text(
                      l10n.signInHere,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> performRegistration(BuildContext context) async {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await context.read<RegisterProvider>().register(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
          );
      if (!context.mounted) return;
      final state = context.read<RegisterProvider>().state;
      if (state is RegisterSuccess) {
        widget.toLoginScreen();
        context.read<PageManager>().returnRegisterResult(
              state.data.message.toString(),
            );
      } else if (state is RegisterError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.fillFieldSuggestion),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
