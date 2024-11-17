import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../di/overlay_manager.dart';
import '../widgets/active_overlay/active_overlay_widget.dart';
import '../widgets/active_overlay/show_active_overlay.dart';


class ActiveOverlayExample extends StatefulWidget {
  const ActiveOverlayExample({super.key});

  @override
  State<ActiveOverlayExample> createState() => _ActiveOverlayExamplleState();
}

class _ActiveOverlayExamplleState extends State<ActiveOverlayExample> {
  @override
  Widget build(BuildContext context) {
    var baseWidth = MediaQuery.sizeOf(context).width;
    var baseHeight = MediaQuery.sizeOf(context).height;
    final overlayManager = Provider.of<OverlayManager>(context);

    // Определение кнопок для первого оверлея
    List<ButtonParams> buttonsThree = [
      ButtonParams(
        text: 'Не обновлять',
        isCloseButton: true,
        onPressed: () {
          print('Не обновлять');
        },
      ),
      ButtonParams(
        text: 'Напомнить позже',
        isCloseButton: true,
        onPressed: () {
          print('Напомнить позже');
        },
      ),
      ButtonParams(
        text: 'Обновить',
        isCloseButton: true,
        onPressed: () {
          print('Обновить');
        },
        color: Colors.yellow,
      ),
    ];

    // Определение кнопки для второго оверлея
    List<ButtonParams> buttonsOne = [
      ButtonParams(
        text: 'Ок',
        isCloseButton: true,
        onPressed: () {
          print('Ок нажато');
        },
        color: Colors.yellow,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Global Overlay Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Вызов первого оверлея (не пропускаемый, без блэкаута)
                showActiveOverlay(
                  context: context,
                  content: Text(
                    'Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! \n\nДоступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! Доступно обновление! ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  onClose: () {
                    print('Overlay with three buttons closed');
                  },
                  buttons: buttonsThree,
                  skippable: false,
                  blackout: false,
                );
              },
              child: Text('Show Overlay with Three Buttons'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Вызов второго оверлея (пропускаемый с блэкаутом)
                showActiveOverlay(
                  context: context,
                  content: Text(
                    'Одно действие',
                    style: TextStyle(fontSize: 18),
                  ),
                  onClose: () {
                    print('Overlay with one button closed');
                  },
                  buttons: buttonsOne,
                  skippable: true,
                  blackout: true,
                );
              },
              child: Text('Show Overlay with One Button'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Вызов третьего оверлея (без кнопок, пропускаемый с блэкаутом)
                showActiveOverlay(
                  context: context,
                  content: Text(
                    'Только сообщение',
                    style: TextStyle(fontSize: 18),
                  ),
                  onClose: () {
                    print('Overlay without buttons closed');
                  },
                  buttons: [], // Без кнопок
                  skippable: true,
                  blackout: true,
                );
              },
              child: Text('Show Overlay without Buttons'),
            ),
          ],
        ),
      ),
    );
  }
}
