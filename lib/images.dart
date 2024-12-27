import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

bool imagesInitialized = false;

class ImagesList {
  static const String circle = 'assets/images/circle.png';
  static const String cloud = 'assets/images/cloud.png';
  static const String ball = 'assets/images/ball.png';
}

class Images {
  static ui.Image? cloudImage;
  static ui.Image? circleImage;
  static ui.Image? ballImage;
}
Future<ui.Image> _loadImage(BuildContext context, String path) async {
  final data = await DefaultAssetBundle.of(context).load(path);
  final bytes = data.buffer.asUint8List();
  final image = await decodeImageFromList(bytes);
  return image;
}

Future<void> loadImages(BuildContext context) async {
  final cloudImage = await _loadImage(context, ImagesList.cloud);
  final circleImage = await _loadImage(context, ImagesList.circle);
  final ballImage = await _loadImage(context, ImagesList.ball);

    Images.cloudImage = cloudImage;
    Images.circleImage = circleImage;
    Images.ballImage = ballImage;
    imagesInitialized = true;
}