import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageManager with ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setPage(int pageIndex) {
    _currentPage = pageIndex;
    notifyListeners();
  }
}

class NewBottomBar extends StatefulWidget {
  final Color backgroundColor;
  final Color? positionColor;
  final double height;
  final List<IconData> icons;
  final Function(int) onPageSelected;

  const NewBottomBar({
    Key? key,
    required this.backgroundColor,
    this.positionColor = const Color(0xFF8BEA00),
    required this.height,
    required this.icons,
    required this.onPageSelected,
  }) : super(key: key);

  @override
  State<NewBottomBar> createState() => _NewBottomBarState();
}

class _NewBottomBarState extends State<NewBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _widthAnimation;
  int _currentPage = 0;

  static const double buttonWidth = 80;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Инициализация начальных значений анимаций
    _positionAnimation = AlwaysStoppedAnimation(_currentPage * buttonWidth + 6);
    _widthAnimation = AlwaysStoppedAnimation(buttonWidth - 12);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToPage(int newPage) {
    final startPosition = _currentPage * buttonWidth + 6;
    final endPosition = newPage * buttonWidth + 6;

    final startWidth = buttonWidth - 14;
    final decreaseWidth = buttonWidth - 24;
    final endWidth = buttonWidth - 14;

    // Создание анимации перемещения
    _positionAnimation = Tween<double>(
      begin: startPosition,
      end: endPosition,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.85, curve: Curves.easeInOut),
    ));

    // Создание анимации ширины
    _widthAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: startWidth, end: decreaseWidth)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ConstantTween(decreaseWidth),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: decreaseWidth, end: endWidth)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
    ]).animate(_controller);

    // Запуск анимации
    _controller.forward(from: 0).then((_) {
      setState(() {
        _currentPage = newPage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<PageManager>(context).currentPage;
    if (currentPage != _currentPage) {
      _animateToPage(currentPage);
    }

    final double totalWidth = buttonWidth * widget.icons.length;

    return Container(
      height: widget.height,
      width: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: widget.height * 0.8,
          width: totalWidth,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Анимация бегунка
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    left: _positionAnimation.value,
                    top: 6,
                    bottom: 6,
                    child: Container(
                      width: _widthAnimation.value,
                      decoration: BoxDecoration(
                        color: widget.positionColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
              // Иконки
              Row(
                children: List.generate(widget.icons.length, (index) {
                  final isSelected = currentPage == index;
                  return SizedBox(
                    width: buttonWidth,
                    child: _NavigationBarItem(
                      icon: widget.icons[index],
                      isSelected: isSelected,
                      onTap: () {
                        Provider.of<PageManager>(context, listen: false)
                            .setPage(index);
                        widget.onPageSelected(index);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationBarItem({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: isSelected ? 28 : 24,
          color: isSelected
              ? Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }
}
