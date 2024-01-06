import 'package:flutter/material.dart';
import 'package:supabase_demo/views/pages/login_page/login_page.dart';
import 'package:supabase_demo/views/pages/register_page/register_page.dart';
import 'package:supabase_demo/views/pages/user_details_page/user_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const LoginPage()));
                },
                child: const Text('login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const RegisterPage()));
                },
                child: const Text('register'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const UserDetailsPage()));
                },
                child: const Text('user details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
