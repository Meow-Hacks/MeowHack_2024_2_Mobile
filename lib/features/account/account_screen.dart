import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/settings/app_settings.dart';
import '../../di/global_data_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _logout(BuildContext context) async {
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    await appSettings.clearTokens(); // Очистка токенов при выходе
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final globalData = Provider.of<GlobalDataProvider>(context);

    // Получаем данные пользователя из провайдера
    final userInfo = globalData.userInfo;

    // Проверка на загрузку данных или их отсутствие
    if (globalData.isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (userInfo.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'Нет данных для отображения.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final fullName =
        '${userInfo['lastname']} ${userInfo['name']} ${userInfo['secondname']}';
    final group = userInfo['group'] ?? 'Не указано';
    final institute = userInfo['institute'] ?? 'Не указано';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _logout(context),
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: Padding(
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground, // Контрастный цвет для темы
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Группа
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Группа:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      group,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Институт
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Институт:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      institute,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
