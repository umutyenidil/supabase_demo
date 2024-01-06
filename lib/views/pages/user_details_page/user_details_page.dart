import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_demo/services/database_service/database_service.dart';

part '_provider.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late final TextEditingController _fcmTokenController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();

    _fcmTokenController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _fcmTokenController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserDetailsPageProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _fcmTokenController,
                  decoration: const InputDecoration(
                    label: Text('FCM Token'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    label: Text('First Name'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    label: Text('Last Name'),
                  ),
                ),
              ),
              _birthDate(),
              _genders(),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genders() {
    return Consumer<UserDetailsPageProvider>(
      builder: (context, provider, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RadioListTile<Gender>(
              title: Text('Male'),
              value: Gender.male,
              groupValue: provider.gender,
              onChanged: (value) {
                if (value != null) provider.setGender(value);
              },
            ),
            RadioListTile<Gender>(
              title: Text('Female'),
              value: Gender.female,
              groupValue: provider.gender,
              onChanged: (value) {
                if (value != null) provider.setGender(value);
              },
            ),
            RadioListTile<Gender>(
              title: Text('Other'),
              value: Gender.other,
              groupValue: provider.gender,
              onChanged: (value) {
                if (value != null) provider.setGender(value);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return Consumer<UserDetailsPageProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: (provider.isSubmitButtonEnabled)
              ? null
              : () async {
                  try {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    context.read<UserDetailsPageProvider>().setSubmitButtonEnabledState(true);

                    await DatabaseService.instance.updateUserDetails(
                      fcmToken: _fcmTokenController.text.trim(),
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      birthDate: provider.birthDate,
                      gender: provider.gender,
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
                      provider.setSubmitButtonEnabledState(false);
                    }
                  }
                },
          child: Center(
            child: provider.isSubmitButtonEnabled
                ? const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text('update'),
          ),
        );
      },
    );
  }

  Widget _birthDate() {
    return Consumer<UserDetailsPageProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          child: Text(provider.birthDate.toString()),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              lastDate: DateTime.now(),
            );

            if (picked != null) {
              provider.setBirthDate(picked);
            }
          },
        );
      },
    );
  }
}
