import 'package:circle_jump/Models/Platform/platform.dart';
import 'package:circle_jump/Models/collector.dart';

class PlatformCollector extends Collector<PlatformModel> {
  @override
  Iterable<PlatformModel> get visibleItems {
    return items.where((platform) {
      return (platform.startAngleDeg <= 0 && platform.startAngleDeg >= -180) ||
          platform.endAngleDeg <= 0 && platform.endAngleDeg >= -180;
    });
  }

  @override
  void removeUnnecessaryItems() {
    items.removeWhere((platform) {
      return platform.endAngleDeg < -180;
    });
  }
}
