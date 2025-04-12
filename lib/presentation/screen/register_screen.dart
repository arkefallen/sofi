import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofi/presentation/provider/register_provider.dart';
import 'package:sofi/presentation/screen/login_screen.dart';
import 'package:sofi/presentation/state/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome,',
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
              'Join us and share your stories with the world. Register yourself by entering your email and password below.',
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
              obscureText: isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () => setState(() {
                          isObscure = !isObscure;
                        }),
                    icon: isObscure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility)),
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
                    return CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    );
                  }
                  return Text(
                    'Register',
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
                    "Already have account?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen()));
                    },
                    child: Text(
                      'Sign in here.',
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
            settings: RouteSettings(
              arguments: state.data.message.toString(),
            ),
          ),
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
        const SnackBar(
          content: Text('Please fill in all fields.'),
        ),
      );
    }
  }
}
