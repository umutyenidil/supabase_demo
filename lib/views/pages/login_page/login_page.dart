import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_demo/services/database_service/database_service.dart';

part '_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginPageProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text('Email address'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                ),
              ),
              Consumer<LoginPageProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: (provider.isRegisterButtonLoading)
                        ? null
                        : () async {
                            try {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              context.read<LoginPageProvider>().setRegisterButtonLoadingState(true);

                              await DatabaseService.instance.login(
                                emailAddress: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            } on DatabaseServiceException catch (databaseServiceException) {
                              print(databaseServiceException.message);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      databaseServiceException.message ?? 'Something went wrong',
                                    ),
                                  ),
                                );
                              }
                            } catch (exception) {
                              print(exception);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      exception.toString(),
                                    ),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                provider.setRegisterButtonLoadingState(false);
                              }
                            }
                          },
                    child: Center(
                      child: provider.isRegisterButtonLoading
                          ? const SizedBox.square(
                              dimension: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('register'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
