// ✨ 新增這一行：引入 Material 套件，這樣才能使用 Color 和 Colors
import 'package:flutter/material.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/property_model.dart';

final List<PropertyListing> dummyListings = [
  PropertyListing(
    id: '1',
    title: '台北灣 - 銀河',
    price: '\$1,880萬',
    address: '新北市淡水區濱海路一段',
    specs: '2房 1廳 28坪',
    videoUrl: 'assets/videos/house1.mp4',
    location: const LatLng(25.1933, 121.4333),
  ),
  PropertyListing(
    id: '2',
    title: '宏盛水公園',
    price: '\$2,580萬',
    address: '新北市淡水區新市五路',
    specs: '3房 2廳 45坪',
    videoUrl: 'assets/videos/house2.mp4',
    location: const LatLng(25.1955, 121.4350),
  ),
  PropertyListing(
    id: '3',
    title: '海上皇宮',
    price: '\$3,200萬',
    address: '新北市淡水區濱海路三段',
    specs: '4房 2廳 60坪',
    videoUrl: 'assets/videos/house3.mp4',
    location: const LatLng(25.1900, 121.4300),
  ),
];

// ✨ 定義社區區塊 (Zone)
class CommunityZone {
  final String name;        
  final Color color;        // 這裡現在就不會報錯了
  final List<LatLng> points;

  CommunityZone({
    required this.name,
    required this.color,
    required this.points,
  });
}

// ✨ 定義多邊形範圍
final List<CommunityZone> dummyZones = [
  CommunityZone(
    name: '台北灣', 
    color: Colors.blue.withOpacity(0.3), // 藍色區塊
    points: const [
      LatLng(25.1940, 121.4325),
      LatLng(25.1940, 121.4340),
      LatLng(25.1925, 121.4340),
      LatLng(25.1925, 121.4325),
    ],
  ),
  CommunityZone(
    name: '宏盛', 
    color: Colors.orange.withOpacity(0.3), // 橘色區塊
    points: const [
      LatLng(25.1960, 121.4345),
      LatLng(25.1960, 121.4360),
      LatLng(25.1950, 121.4360),
      LatLng(25.1950, 121.4345),
    ],
  ),
];