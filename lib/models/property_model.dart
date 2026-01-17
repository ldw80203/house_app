// ✅ 正確：只引用 Google Maps
import 'package:google_maps_flutter/google_maps_flutter.dart'; 

// ❌ 如果你有看到下面這一行，請刪掉它！
// import 'package:latlong2/latlong.dart'; 

class PropertyListing {
  final String id;
  final String title;
  final String price;
  final String address;
  final String specs;
  final String videoUrl;
  final LatLng location; // 這裡現在會使用 google_maps_flutter 的 LatLng

  PropertyListing({
    required this.id,
    required this.title,
    required this.price,
    required this.address,
    required this.specs,
    required this.videoUrl,
    required this.location,
  });
}