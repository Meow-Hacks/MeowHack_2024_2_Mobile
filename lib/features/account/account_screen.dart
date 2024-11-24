import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meow_hack_app/features/account/account_api.dart';
import '../../../app/settings/app_settings.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = _fetchUserInfo();
  }

  Future<Map<String, dynamic>> _fetchUserInfo() async {
    final api = AccountApi(context);
    return await api.fetchUserInfo();
  }

  void _logout(BuildContext context) async {
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    await appSettings.clearTokens(); // Clear tokens on logout
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () => _logout(context),
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки данных. Пожалуйста, попробуйте позже.',
                style: TextStyle(fontSize: 16, color: theme.colorScheme.error),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Нет данных для отображения.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final userInfo = snapshot.data!;
          final fullName =
              '${userInfo['lastname']} ${userInfo['name']} ${userInfo['secondname']}';
          final group = userInfo['group'] ?? 'Не указано';
          final institute = userInfo['institute'] ?? 'Не указано';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Аватарка
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    userInfo['name'][0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // ФИО
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Группа
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Группа:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        group,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Институт
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Институт:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        institute,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
