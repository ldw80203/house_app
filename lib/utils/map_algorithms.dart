import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapAlgorithms {
  // 🧮 演算法 1：凸包 (Convex Hull) - 畫出包圍點的多邊形
  static List<LatLng> getConvexHull(List<LatLng> points) {
    if (points.length <= 2) return points;
    // 先排序
    points.sort((a, b) {
      int comp = a.latitude.compareTo(b.latitude);
      if (comp != 0) return comp;
      return a.longitude.compareTo(b.longitude);
    });

    double crossProduct(LatLng o, LatLng a, LatLng b) {
      return (a.latitude - o.latitude) * (b.longitude - o.longitude) -
             (a.longitude - o.longitude) * (b.latitude - o.latitude);
    }

    // 下半部
    List<LatLng> lower = [];
    for (var p in points) {
      while (lower.length >= 2 && crossProduct(lower[lower.length - 2], lower.last, p) <= 0) {
        lower.removeLast();
      }
      lower.add(p);
    }
    // 上半部
    List<LatLng> upper = [];
    for (var p in points.reversed) {
      while (upper.length >= 2 && crossProduct(upper[upper.length - 2], upper.last, p) <= 0) {
        upper.removeLast();
      }
      upper.add(p);
    }
    lower.removeLast();
    upper.removeLast();
    return [...lower, ...upper];
  }

  // 🔵 演算法 2：畫圓形多邊形
  static List<LatLng> createCirclePolygon(LatLng center, double radius) {
    List<LatLng> circlePoints = [];
    const int sides = 12;
    for (int i = 0; i < sides; i++) {
      double angle = (2 * pi / sides) * i;
      double dx = radius * cos(angle);
      double dy = radius * sin(angle);
      circlePoints.add(LatLng(center.latitude + dy, center.longitude + dx));
    }
    return circlePoints;
  }

  // 🔍 演算法 3：計算縮放邊界
  static LatLngBounds getBounds(List<LatLng> points) {
    double minLat = 90.0, maxLat = -90.0;
    double minLng = 180.0, maxLng = -180.0;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat - 0.01, minLng - 0.01),
      northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
    );
  }
}