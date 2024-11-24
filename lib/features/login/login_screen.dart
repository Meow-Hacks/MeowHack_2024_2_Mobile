import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meow_hack_app/features/login/login_api.dart';
import 'package:provider/provider.dart';

import '../../app/settings/app_settings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isStudent = true; // Переключатель для роли
  late double _selectorPosition; // Для позиции выделения
  bool _isLoading = false; // Индикатор загрузки
  String? _errorMessage; // Сообщение об ошибке

  @override
  void initState() {
    super.initState();
    _selectorPosition = 0.0;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final loginApi = LoginApi(context); // Передаем контекст

    try {
      Map<String, dynamic> result;

      // Вызываем нужный метод в зависимости от роли
      if (isStudent) {
        result = await loginApi.studentLogin(email: email, password: password);
        await Provider.of<AppSettings>(context, listen: false).setRole('student');
      } else {
        result = await loginApi.teacherLogin(email: email, password: password);
        await Provider.of<AppSettings>(context, listen: false).setRole('teacher');
      }

      // Сохраняем токены
      await Provider.of<AppSettings>(context, listen: false).setTokens(
        result['access_token'],
        result['refresh_token'],
        DateTime.now().add(const Duration(hours: 1)),
      );

      print('Login successful: ${result['access_token']}');
    } catch (e) {
      print('Error during login: $e');
      _showError(context, 'Ошибка авторизации: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Переключение роли
                LayoutBuilder(
                  builder: (context, constraints) {
                    double buttonWidth = constraints.maxWidth / 2;

                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          left: _selectorPosition + 6,
                          top: 6,
                          bottom: 6,
                          child: Container(
                            width: buttonWidth - 12,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isDarkMode ? Colors.white : Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isStudent = true;
                                      _selectorPosition = 0.0;
                                    });
                                  },
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isStudent
                                            ? theme.colorScheme.onPrimary
                                            : theme.colorScheme.primary,
                                      ),
                                      child: const Text('Я ученик'),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isStudent = false;
                                      _selectorPosition = buttonWidth;
                                    });
                                  },
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: !isStudent
                                            ? theme.colorScheme.onPrimary
                                            : theme.colorScheme.primary,
                                      ),
                                      child: const Text('Я учитель'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                // Поле Email
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isDarkMode ? Colors.white : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    cursorColor: isDarkMode ? Colors.white : Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black.withOpacity(0.6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Поле Пароль
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isDarkMode ? Colors.white : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    cursorColor: isDarkMode ? Colors.white : Colors.black,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      hintStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black.withOpacity(0.6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Кнопка войти
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text('Войти'),
                ),
                const SizedBox(height: 16),
                // Сообщение об ошибке
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                // Кнопка восстановить пароль
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    print('Reset password requested');
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Text(
                    'Восстановить пароль',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
