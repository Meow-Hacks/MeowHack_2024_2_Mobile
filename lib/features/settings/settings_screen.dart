import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/settings/app_settings.dart';
import '../../app/uikit/widgets/active_overlay/active_overlay_widget.dart';
import '../account/account_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    bool showTaskCount = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _SettingItem(
            icon: Icons.person,
            title: 'Профиль',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
          _SettingItem(
            icon: appSettings.themeMode == ThemeMode.dark
                ? Icons.nightlight_round
                : Icons.wb_sunny,
            title: 'Тема',
            trailing: CupertinoSwitch(
              value: appSettings.themeMode == ThemeMode.dark,
              onChanged: (value) {
                final newThemeMode =
                value ? ThemeMode.dark : ThemeMode.light;
                appSettings.setThemeMode(newThemeMode);
              },
            ),
          ),
          _SettingItem(
            icon: Icons.calendar_today,
            title: 'Отображать успеваемость в календаре',
            trailing: CupertinoSwitch(
              value: appSettings.gradeVisualization,
              onChanged: (value) {
                appSettings.setGradeVisualization(value);
              },
            ),
          ),
          _SettingItem(
            icon: Icons.task,
            title: 'Отображать количество заданий',
            trailing: CupertinoSwitch(
              value: showTaskCount,
              onChanged: (value) {
                setState(() {
                  showTaskCount = !showTaskCount;
                });
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 100),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                _showLogoutConfirmation(context);
              },
              child: const Text('Выход', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ActiveOverlayWidget(
          backgroundColor: theme.dialogBackgroundColor,
          content: const Text(
            'Вы действительно хотите выйти?',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          onClose: () {
            Navigator.of(context).pop();
          },
          buttons: [
            ButtonParams(
              text: 'Отмена',
              color: Colors.grey,
              isCloseButton: true,
            ),
            ButtonParams(
              text: 'Выйти',
              color: Colors.red,
              onPressed: () async {
                final appSettings = Provider.of<AppSettings>(context, listen: false);
                await appSettings.clearTokens(); // Очистка токенов
                Navigator.of(context).pop(); // Закрыть оверлей
              },
              isCloseButton: true,
            ),
          ],
        );
      },
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70, // Устанавливаем одинаковую высоту
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (theme.brightness == Brightness.dark) BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(icon, size: 24, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyLarge,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
