import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/property_model.dart';
import '../../utils/map_algorithms.dart';
import '../widgets/community_bottom_sheet.dart';

class MapSearchPage extends StatefulWidget {
  final List<PropertyListing> listings;

  const MapSearchPage({super.key, required this.listings});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  
  final TextEditingController _searchController = TextEditingController();
  final LatLng _defaultCenter = const LatLng(25.1933, 121.4333);

  @override
  void initState() {
    super.initState();
    // ✨ 修正 1：初始化時不要操作鍵盤 FocusScope
    _resetMapState(closeKeyboard: false);
  }

  // ✨ 修正 2：增加 closeKeyboard 參數，預設為 true
  void _resetMapState({bool closeKeyboard = true}) {
    setState(() {
      _polygons.clear(); 
      _markers = widget.listings.map((house) {
        return Marker(
          markerId: MarkerId(house.id),
          position: house.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _onHouseSelected(house.title),
        );
      }).toSet();
      
      // ✨ 修正 3：加判斷，只有非初始化時才收起鍵盤
      if (closeKeyboard) {
        FocusScope.of(context).unfocus(); 
      }
    });
  }

  void _onHouseSelected(String title) {
    String communityKey = title.substring(0, 2); 

    List<PropertyListing> targetHouses = widget.listings
        .where((h) => h.title.startsWith(communityKey))
        .toList();
    
    if (targetHouses.isEmpty) return;

    List<LatLng> points = targetHouses.map((h) => h.location).toList();

    List<LatLng> polygonPoints = [];
    if (points.length >= 3) {
      polygonPoints = MapAlgorithms.getConvexHull(points);
    } else {
      polygonPoints = MapAlgorithms.createCirclePolygon(points.first, 0.0015);
    }

    setState(() {
      _markers = targetHouses.map((house) {
        return Marker(
          markerId: MarkerId(house.id),
          position: house.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _showBottomSheet(communityKey, targetHouses),
        );
      }).toSet();

      _polygons.clear();
      _polygons.add(
        Polygon(
          polygonId: PolygonId(communityKey),
          points: polygonPoints,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
          consumeTapEvents: true,
          onTap: () => _showBottomSheet(communityKey, targetHouses),
        ),
      );
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(MapAlgorithms.getBounds(points), 60)
    );

    _showBottomSheet(communityKey, targetHouses);
  }

  void _showBottomSheet(String title, List<PropertyListing> houses) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return CommunityBottomSheet(
              title: "$title 系列",
              listings: houses,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  void _searchAndNavigate(String query) {
    if (query.isEmpty) return;
    try {
      final result = widget.listings.firstWhere(
        (house) => house.title.contains(query) || house.address.contains(query),
      );
      _onHouseSelected(result.title);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("找不到相關社區物件")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (c) {
              _mapController = c;
              c.setMapStyle('[{"featureType": "poi", "stylers": [{"visibility": "off"}]}]');
              Future.delayed(const Duration(milliseconds: 500), () {
                if(widget.listings.isNotEmpty) {
                   var allPoints = widget.listings.map((e) => e.location).toList();
                   _mapController.animateCamera(
                     CameraUpdate.newLatLngBounds(MapAlgorithms.getBounds(allPoints), 50)
                   );
                }
              });
            },
            initialCameraPosition: CameraPosition(target: _defaultCenter, zoom: 13.0),
            markers: _markers,
            polygons: _polygons,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            // 點擊空白處時，這裡使用預設值 true，所以會收起鍵盤
            onTap: (_) => _resetMapState(),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "搜尋社區...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFE0AA3E)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.grey),
                      onPressed: () => _searchAndNavigate(_searchController.text),
                    ),
                  ),
                  onSubmitted: _searchAndNavigate,
                ),
              ),
            ),
          ),
          
          Positioned(
            right: 20,
            bottom: 100,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.crop_free, color: Color(0xFFE0AA3E)),
              onPressed: () {
                _resetMapState();
                if(widget.listings.isNotEmpty) {
                   var allPoints = widget.listings.map((e) => e.location).toList();
                   _mapController.animateCamera(
                     CameraUpdate.newLatLngBounds(MapAlgorithms.getBounds(allPoints), 50)
                   );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}