import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/l10n/app_localizations.dart';

class DataDownloader extends StatefulWidget {
  final int? specificGrade; 
  final VoidCallback onComplete;

  const DataDownloader({super.key, this.specificGrade, required this.onComplete});

  @override
  State<DataDownloader> createState() => _DataDownloaderState();
}

class _DataDownloaderState extends State<DataDownloader> {
  bool _isInstalling = false;
  String _status = '';
  double _installProgress = 0; 
  double _overallProgress = 0;  
  final FocusNode _gradeFocusNode = FocusNode();
  final FocusNode _allFocusNode = FocusNode();

  @override
  void dispose() {
    _gradeFocusNode.dispose();
    _allFocusNode.dispose();
    super.dispose();
  }

  Future<void> _startInstall(List<int> gradesToInstall) async {
    final l10n = AppLocalizations.of(context);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    setState(() {
      _isInstalling = true;
      _overallProgress = 0;
      _installProgress = 0;
    });

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final targetDir = Directory('${appDir.path}/Surah');
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      for (int i = 0; i < gradesToInstall.length; i++) {
        int g = gradesToInstall[i];
        if (mounted) {
          setState(() {
            _status = isArabic 
                ? 'جاري تجهيز محتوى ${l10n.grade(g)}...' 
                : 'Preparing ${l10n.grade(g)}...';
          });
        }

        // 1. Load local zip asset from app bundle
        final assetPath = 'sura/$g.zip';
        final byteData = await rootBundle.load(assetPath);

        // 2. Write temporarily to disk for stream decoding
        final zipFile = File('${appDir.path}/temp_$g.zip');
        final sink = zipFile.openWrite();
        final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
        sink.add(bytes);
        await sink.flush();
        await sink.close();

        if (mounted) {
          setState(() {
            _status = isArabic 
                ? 'جاري تثبيت ملفات ${l10n.grade(g)}...' 
                : '${l10n.installing} ${l10n.grade(g)}...';
          });
        }

        // 3. Decode buffer and extract to Surah directory
        final input = InputFileStream(zipFile.path);
        final archive = ZipDecoder().decodeBuffer(input);

        final totalFiles = archive.length;
        int count = 0;
        for (final file in archive) {
          String name = file.name.replaceAll('\\', '/');
          if (name.startsWith('/')) name = name.substring(1);

          String relativePath = name;
          if (relativePath.toLowerCase().startsWith('surah/')) {
            relativePath = relativePath.substring(6);
          }
          final String path = '${targetDir.path}/$relativePath';

          if (file.isFile) {
            final outFile = File(path);
            await outFile.parent.create(recursive: true);
            await outFile.writeAsBytes(file.content as List<int>);
          } else {
            await Directory(path).create(recursive: true);
          }
          count++;
          if (count % 8 == 0 || count == totalFiles) {
            if (mounted) {
              setState(() {
                _installProgress = count / (totalFiles > 0 ? totalFiles : 1);
                _overallProgress = (i + _installProgress) / gradesToInstall.length;
                _status = isArabic
                    ? 'جاري تثبيت ${l10n.grade(g)} ($count / $totalFiles)'
                    : '${l10n.installing} ${l10n.grade(g)} ($count / $totalFiles)';
              });
            }
            await Future.delayed(const Duration(milliseconds: 2));
          }
        }
        input.close();
        if (await zipFile.exists()) await zipFile.delete();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('grade_${g}_downloaded', true);

        if (mounted) {
          setState(() => _overallProgress = (i + 1) / gradesToInstall.length);
        }
      }

      if (gradesToInstall.length >= 6) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('data_downloaded_v3', true);
      }

      widget.onComplete();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInstalling = false;
          _status = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context);
    
    return Container(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 400,
            height: 600,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/download_bg.png', 
                    fit: BoxFit.fill,
                  ),
                ),
                
                Positioned(
                  top: 10,
                  right: isArabic ? null : 10,
                  left: isArabic ? 10 : null,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                Positioned.fill(
                  child: Center(
                    child: _isInstalling
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(40, 140, 40, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: _overallProgress, 
                                          minHeight: 14,
                                          color: Colors.green,
                                          backgroundColor: Colors.black12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 45,
                                      child: Text(
                                        '${(_overallProgress * 100).toInt()}%', 
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  _status, 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 90),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.green.shade400, width: 1.5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.wifi_off_rounded, size: 18, color: Colors.green),
                                    const SizedBox(width: 6),
                                    Text(
                                      isArabic ? "يعمل بدون إنترنت (Offline)" : "Works completely offline",
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildButton(
                                    node: _gradeFocusNode, 
                                    label: isArabic 
                                        ? "تثبيت ${l10n.grade(widget.specificGrade ?? 1)}" 
                                        : "Install ${l10n.grade(widget.specificGrade ?? 1)}",
                                    onTap: () => _startInstall([widget.specificGrade ?? 1]),
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 15),
                                  _buildButton(
                                    node: _allFocusNode, 
                                    label: isArabic ? "تثبيت الكل" : l10n.downloadAll,
                                    onTap: () => _startInstall([1,2,3,4,5,6]),
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required FocusNode node, required String label, required VoidCallback onTap, required Color color}) {
    return FocusableActionDetector(
      focusNode: node,
      autofocus: node == _gradeFocusNode,
      actions: { ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { onTap(); return null; }) },
      child: Builder(builder: (context) {
        bool focused = Focus.of(context).hasFocus;
        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: focused ? color : Colors.white.withAlpha(200),
              border: Border.all(color: color, width: 2),
              boxShadow: [if (focused) BoxShadow(color: color.withAlpha(100), blurRadius: 15, spreadRadius: 2)],
            ),
            child: Text(label, style: TextStyle(color: focused ? Colors.white : color, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        );
      }),
    );
  }
}
