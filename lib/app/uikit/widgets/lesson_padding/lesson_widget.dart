import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meow_hack_app/models/lesson_model.dart';

class LessonWidget extends StatefulWidget {
  final LessonModel lesson;

  const LessonWidget({Key? key, required this.lesson}) : super(key: key);

  @override
  _LessonWidgetState createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _reverseSlideAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Вылет слева
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _reverseSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0), // Возврат влево
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
          if (_isExpanded) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхняя строка: только название
            Text(
              lesson.subject,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Нижняя строка: тип, аудитория, время
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Тип занятия (слева)
                Text(
                  lesson.type,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
                // Аудитория (по центру)
                Expanded(
                  child: Center(
                    child: Text(
                      lesson.auditoryName,
                      style: TextStyle(
                        fontSize: 18,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                // Время (справа)
                Text(
                  '${DateFormat.Hm().format(lesson.startTime)} - ${DateFormat.Hm().format(lesson.endTime)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            // Развёрнутая версия с анимацией вылета текста
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Group: ${lesson.group}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Teacher: ${lesson.teacherName} ${lesson.teacherSecondName} ${lesson.teacherLastName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Auditory: ${lesson.auditoryName} (${lesson.auditoryCapacity} seats)',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'Branch: ${lesson.branchName}, ${lesson.branchAddress}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (lesson.task != null)
                    SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Task: ${lesson.task}',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                ],
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
