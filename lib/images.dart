import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

bool imagesInitialized = false;

class ImagesList {
  static const String circle = 'assets/images/circle_road.png';
  static const String cloud = 'assets/images/cloud.png';
  static const String ball = 'assets/images/ball.png';
  static const String block = 'assets/images/block.png';
  static const String coin = 'assets/images/coin.png';
  static const String longSpike = 'assets/images/long_metal_spike.png';
  static const String smallSpike = 'assets/images/small_metal_spike.png';
}

class Images {
  static ui.Image? cloudImage;
  static ui.Image? circleImage;
  static ui.Image? ballImage;
  static ui.Image? blockImage;
  static ui.Image? coinImage;
  static ui.Image? longSpikeImage;
  static ui.Image? smallSpikeImage;
}

class ImageLoader {
  final BuildContext _context;

  ImageLoader(this._context);

  Future<ui.Image> loadImage(String assetPath) async {
    final data = await DefaultAssetBundle.of(_context).load(assetPath);
    return await decodeImageFromList(data.buffer.asUint8List());
  }
}
