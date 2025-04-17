import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/core/l10n/l10n.dart';
import 'package:sofi/presentation/provider/login_provider.dart';
import 'package:sofi/presentation/screen/home_screen.dart';
import 'package:sofi/presentation/screen/register_screen.dart';
import 'package:sofi/presentation/state/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? message =
          ModalRoute.of(context)?.settings.arguments as String?;
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
    super.initState();
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
                l10n.hello,
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
                l10n.loginScreenSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 24),
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
                obscureText: isObscure,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      isObscure = !isObscure;
                    }),
                    icon: isObscure
                        ? Icon(
                            Icons.visibility_off,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : Icon(
                            Icons.visibility,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                  ),
                ),
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  performLogin(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Consumer<LoginProvider>(
                  builder: (context, loginProvider, child) {
                    if (loginProvider.state is LoginLoading) {
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
                      'Login',
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
                      l10n.dontHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const RegisterScreen()));
                      },
                      child: Text(
                        l10n.signUpHere,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> performLogin(BuildContext context) async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await context.read<LoginProvider>().login(
            _emailController.text,
            _passwordController.text,
          );
      if (!context.mounted) return;
      final loginState = context.read<LoginProvider>().state;
      if (loginState is LoginSuccess) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(
              title: "Sofi",
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else if (loginState is LoginError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.loginFailed}. ${loginState.message}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.fillFieldSuggestion}.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
