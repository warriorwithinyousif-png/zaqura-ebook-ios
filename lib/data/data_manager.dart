import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/video.dart';
import 'package:myapp/models/book.dart';
import 'package:myapp/models/sound.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  Directory? _appDir;

  Future<void> init() async {
    _appDir ??= await getApplicationDocumentsDirectory();
  }

  Future<bool> isGradeDownloaded(int grade) async {
    if (_appDir == null) await init();
    final prefs = await SharedPreferences.getInstance();
    // Check if the individual grade is marked as done or if "all" was previously done
    bool specific = prefs.getBool('grade_${grade}_downloaded') ?? false;
    bool all = prefs.getBool('data_downloaded_v3') ?? false;
    
    // Also verify the folder actually exists
    final gradeDir = Directory('${_appDir!.path}/Surah/$grade');
    return (specific || all) && await gradeDir.exists();
  }

  Future<List<Video>> getVideosForGrade(int grade) async {
    final List<Video> videos = [];
    if (_appDir == null) await init();
    final root = '${_appDir!.path}/Surah';
    
    final videoNamesMap = {
      1: {1: "the opening", 2: "the win", 3: "almasad", 4: "the dedication", 10: "the afternoon"},
      2: {5: "alfalaq", 8: "The Most Merciful", 11: "Leeches", 12: "the elephant", 13: "the alqadr", 15: "Quraysh"},
      3: {5: "alfalaq", 6: "The people", 7: "figs", 9: "Alsharh", 14: "Alhumaza"},
      4: {21: "the chair", 22: "The night", 23: "late morning", 24: "the earthquick", 25: "the plate"},
      5: {26: "the property", 27: "The pencile", 28: "the Ascents", 29: "the highness", 30: "The Country"},
      6: {16: "Luqman", 17: "The Most Merciful", 18: "the Star", 19: "the human", 20: "The Sun"},
    };

    final gradeDir = Directory('$root/$grade');
    if (await gradeDir.exists()) {
      final names = videoNamesMap[grade] ?? {};
      for (var entry in names.entries) {
        File file = File('${gradeDir.path}/${entry.key}.mp4');
        if (!await file.exists()) file = File('${gradeDir.path}/${entry.key}.MP4');
        if (await file.exists()) {
          videos.add(Video(id: entry.key, name: entry.value, path: file.path));
        }
      }
    }

    if (grade == 3 && !videos.any((v) => v.id == 5)) {
      final grade2Dir = Directory('$root/2');
      if (await grade2Dir.exists()) {
        File f = File('${grade2Dir.path}/5.mp4');
        if (!await f.exists()) f = File('${grade2Dir.path}/5.MP4');
        if (await f.exists()) videos.add(Video(id: 5, name: "alfalaq", path: f.path));
      }
    }
    return videos;
  }

  Future<Book> getBookForGrade(int grade) async {
    if (_appDir == null) await init();
    final root = '${_appDir!.path}/Surah';
    Directory bookDir = Directory('$root/$grade/book1');
    if (!await bookDir.exists()) bookDir = Directory('$root/$grade/Book1');
    
    if (!await bookDir.exists()) return Book(title: 'the book', pages: []);
    
    final List<FileSystemEntity> files = bookDir.listSync();
    final imagePaths = files
        .where((f) => f.path.toLowerCase().endsWith('.png') || f.path.toLowerCase().endsWith('.jpg'))
        .map((f) => f.path).toList();

    imagePaths.sort((a, b) {
      final re = RegExp(r'\((\d+)\)');
      final mA = re.firstMatch(a.split(Platform.pathSeparator).last);
      final mB = re.firstMatch(b.split(Platform.pathSeparator).last);
      if (mA != null && mB != null) return int.parse(mA.group(1)!).compareTo(int.parse(mB.group(1)!));
      return a.compareTo(b);
    });

    return Book(title: 'the book', pages: imagePaths);
  }

  Future<List<Sound>> getSoundsForGrade(int grade) async => [];
}
