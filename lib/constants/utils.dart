import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];

  try {
    debugPrint('Starting image picker...');

    final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();

    debugPrint('Image picker result: $pickedFiles');

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (var pickedFile in pickedFiles) {
        images.add(File(pickedFile.path));
        debugPrint('Added image: ${pickedFile.path}');
      }
      debugPrint('Total images selected: ${images.length}');
    } else {
      debugPrint('No files selected or user canceled');
    }

  } catch (e) {
    debugPrint('Error picking images: $e');
    throw e;
  }

  return images;
}