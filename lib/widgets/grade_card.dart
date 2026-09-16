import 'package:flutter/material.dart';
import 'package:myapp/screens/grade_screen.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/data/data_manager.dart';
import 'package:myapp/widgets/data_downloader.dart';

class GradeCard extends StatefulWidget {
  final int grade;
  const GradeCard({super.key, required this.grade});

  @override
  GradeCardState createState() => GradeCardState();
}

class GradeCardState extends State<GradeCard>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChanged(bool focused) {
    setState(() => _isFocused = focused);
    if (focused) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleTap() async {
    final dataManager = DataManager();
    bool isDownloaded =
        await dataManager.isGradeDownloaded(widget.grade);

    if (isDownloaded) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GradeScreen(grade: widget.grade),
          ),
        );
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DataDownloader(
            specificGrade: widget.grade,
            onComplete: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GradeScreen(grade: widget.grade),
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FocusableActionDetector(
      onFocusChange: _handleFocusChanged,
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _handleTap();
            return null;
          },
        ),
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _isFocused
                      ? theme.primaryColor.withAlpha(80)
                      : Colors.black.withAlpha(30),
                  blurRadius: _isFocused ? 25 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(150),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isFocused)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.primaryColor,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        AppLocalizations.of(context)
                            .grade(widget.grade),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
