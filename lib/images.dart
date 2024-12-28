import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

bool imagesInitialized = false;

class ImagesList {
  static const String circle = 'assets/images/circle.png';
  static const String cloud = 'assets/images/cloud.png';
  static const String ball = 'assets/images/ball.png';
}

class Images {
  static late ui.Image cloudImage;
  static late ui.Image circleImage;
  static late ui.Image ballImage;
}

class _ImageLoader {
  final BuildContext _context;

  _ImageLoader(this._context);

  Future<ui.Image> loadImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(_context).load(assetPath);
    return await decodeImageFromList(data.buffer.asUint8List());
  }
}

Future<void> loadImages(BuildContext context) async {
  final loader = _ImageLoader(context);
  final cloudImage = await loader.loadImage(ImagesList.cloud);
  final circleImage = await loader.loadImage(ImagesList.circle);
  final ballImage = await loader.loadImage(ImagesList.ball);

  Images.cloudImage = cloudImage;
  Images.circleImage = circleImage;
  Images.ballImage = ballImage;
  imagesInitialized = true;
}
