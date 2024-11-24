import 'package:flutter/material.dart';

class ActiveOverlayWidget extends StatefulWidget {
  final Widget content;
  final VoidCallback onClose;
  final List<ButtonParams> buttons;
  final bool blackout;
  final bool skippable;
  final Color backgroundColor;

  const ActiveOverlayWidget({
    Key? key,
    required this.content,
    required this.onClose,
    this.buttons = const [],
    this.blackout = true,
    this.skippable = true,
    this.backgroundColor = Colors.white, // Добавлен параметр цвета фона
  }) : super(key: key);

  @override
  _ActiveOverlayWidgetState createState() => _ActiveOverlayWidgetState();
}

class _ActiveOverlayWidgetState extends State<ActiveOverlayWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _contentKey = GlobalKey();
  double _overlayHeight = 300;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeight());
    _controller.forward();
  }

  void _measureHeight() {
    final RenderBox? renderBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _overlayHeight = renderBox.size.height;
        _controller.reset();
        _controller.forward();
      });
    }
  }

  void close() {
    _controller.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            if (widget.blackout)
              GestureDetector(
                onTap: widget.skippable ? close : null,
                child: AnimatedOpacity(
                  opacity: _animation.value,
                  duration: const Duration(milliseconds: 50),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            Positioned(
              bottom: -_overlayHeight + (_overlayHeight * _animation.value + 5),
              left: 5,
              right: 5,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  key: _contentKey,
                  constraints: const BoxConstraints(minHeight: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor, // Используем цвет фона
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(child: widget.content),
                          if (widget.buttons.isNotEmpty)
                            SizedBox(height: ((widget.buttons.length / 2).ceil() * 50) + ((widget.buttons.length / 2).ceil() - 1) * 10 + 10),
                        ],
                      ),
                      if (widget.buttons.isNotEmpty)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: _buildButtonRow(widget.buttons),
                        ),
                      if (widget.skippable)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: close,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtonRow(List<ButtonParams> buttons) {
    List<Widget> rows = [];
    for (int i = 0; i < buttons.length; i += 2) {
      if (i + 1 < buttons.length) {
        rows.add(
          Row(
            children: [
              _buildButton(buttons[i]),
              _buildButton(buttons[i + 1]),
            ],
          ),
        );
      } else {
        rows.add(
          Row(
            children: [
              _buildButton(buttons[i]),
            ],
          ),
        );
      }
    }

    return Column(
      children: rows,
    );
  }

  Widget _buildButton(ButtonParams button) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () {
            if (button.isCloseButton) {
              button.onPressed?.call();
              close();
            } else {
              button.onPressed?.call();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: button.color ?? Colors.grey[300],
            padding: const EdgeInsets.all(10),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
          child: Text(
            button.text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ButtonParams {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isCloseButton;

  ButtonParams({
    required this.text,
    this.onPressed,
    this.color,
    this.isCloseButton = false,
  });
}
