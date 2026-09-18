import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/data/data_manager.dart';
import 'package:myapp/models/video.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/screens/video_player_screen.dart';
import 'package:myapp/screens/book_reader_screen.dart';
import 'package:myapp/l10n/app_localizations.dart';

class GradeScreen extends StatelessWidget {
  final int grade;
  const GradeScreen({super.key, required this.grade});

  Future<Map<String, dynamic>> _loadContent() async {
    final dataManager = DataManager();
    await dataManager.init();
    final videos = await dataManager.getVideosForGrade(grade);
    final book = await dataManager.getBookForGrade(grade);
    return {'videos': videos, 'book': book};
  }

  String _getTranslatedSurahName(BuildContext context, Video video) {
    final l10n = AppLocalizations.of(context);

    switch (video.id) {
      case 1: return l10n.surah_1;
      case 2: return l10n.surah_2;
      case 3: return l10n.surah_3;
      case 4: return l10n.surah_4;
      case 5: return l10n.surah_5;
      case 6: return l10n.surah_6;
      case 7: return l10n.surah_7;
      case 8: return l10n.surah_8;
      case 9: return l10n.surah_9;
      case 10: return l10n.surah_10;
      case 11: return l10n.surah_11;
      case 12: return l10n.surah_12;
      case 13: return l10n.surah_13;
      case 14: return l10n.surah_14;
      case 15: return l10n.surah_15;
      case 16: return l10n.surah_16;
      case 17: return l10n.surah_17;
      case 18: return l10n.surah_18;
      case 19: return l10n.surah_19;
      case 20: return l10n.surah_20;
      case 21: return l10n.surah_21;
      case 22: return l10n.surah_22;
      case 23: return l10n.surah_23;
      case 24: return l10n.surah_24;
      case 25: return l10n.surah_25;
      case 26: return l10n.surah_26;
      case 27: return l10n.surah_27;
      case 28: return l10n.surah_28;
      case 29: return l10n.surah_29;
      case 30: return l10n.surah_30;
      default: return video.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    int crossAxisCount = MediaQuery.of(context).size.width > 900
        ? 4
        : MediaQuery.of(context).size.width > 600
            ? 3
            : 2;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.grade(grade))),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data?['videos'] as List<Video>? ?? [];
          final book = snapshot.data?['book'] as Book?;

          final List<Widget> items = [];

          for (var video in videos) {
            items.add(_ModernCard(
              icon: Icons.play_circle_fill,
              color: Colors.green,
              title: _getTranslatedSurahName(context, video),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      video: video,
                      title: _getTranslatedSurahName(context, video),
                    ),
                  ),
                );
              },
            ));
          }

          if (book != null && book.pages.isNotEmpty) {
            items.add(_ModernCard(
              icon: Icons.menu_book_rounded,
              color: Colors.blue,
              title: l10n.theBook,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookReaderScreen(book: book),
                  ),
                );
              },
            ));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) => items[index],
          );
        },
      ),
    );
  }
}

class _ModernCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ModernCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<_ModernCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _isFocused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isFocused ? 1.1 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: _isFocused
                ? widget.color.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: _isFocused ? widget.color : Colors.grey.withValues(alpha: 0.3),
              width: 3,
            ),
            boxShadow: [
              if (_isFocused)
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 60, color: widget.color),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
