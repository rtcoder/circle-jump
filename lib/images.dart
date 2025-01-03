import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

bool imagesInitialized = false;

class ImagesList {
  static const String circle = 'assets/images/circle_road.png';
  static const String cloud = 'assets/images/cloud.png';
  static const String ball = 'assets/images/ball.png';
  static const String block = 'assets/images/block.png';
  static const String coin = 'assets/images/coin.png';
}

class Images {
  static late ui.Image cloudImage;
  static late ui.Image circleImage;
  static late ui.Image ballImage;
  static late ui.Image blockImage;
}

class ImageLoader {
  final BuildContext _context;

  ImageLoader(this._context);

  Future<ui.Image> loadImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(_context).load(assetPath);
    return await decodeImageFromList(data.buffer.asUint8List());
  }
}

Future<void> loadImages(BuildContext context) async {
  final loader = ImageLoader(context);
  final cloudImage = await loader.loadImage(ImagesList.cloud);
  final circleImage = await loader.loadImage(ImagesList.circle);
  final ballImage = await loader.loadImage(ImagesList.ball);
  final block = await loader.loadImage(ImagesList.block);

  Images.cloudImage = cloudImage;
  Images.circleImage = circleImage;
  Images.ballImage = ballImage;
  Images.blockImage = block;

  imagesInitialized = true;
}
