import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/book.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';

class BookReaderScreen extends StatefulWidget {
  final Book book;

  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> pairs = [];
    for (var i = 0; i < widget.book.pages.length; i += 2) {
      final pair = [widget.book.pages[i]];
      if (i + 1 < widget.book.pages.length) {
        pair.add(widget.book.pages[i + 1]);
      }
      pairs.add(pair);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _controller.nextPage();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _controller.previousPage();
            }
          }
        },
        child: widget.book.pages.isEmpty 
          ? const Center(child: Text("No images found", style: TextStyle(color: Colors.white)))
          : CarouselSlider.builder(
              carouselController: _controller,
              itemCount: pairs.length,
              itemBuilder: (context, index, realIndex) {
                final pair = pairs[index];
                return Row(
                  children: pair.map((path) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(
                        File(path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )).toList(),
                );
              },
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
              ),
            ),
      ),
    );
  }
}
