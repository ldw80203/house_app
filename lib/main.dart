import 'package:flutter/material.dart';
import 'core/app_constants.dart';
import 'models/property_model.dart';
// 記得 import 這三個新檔案
import 'services/navigation_service.dart';
import 'views/widgets/floating_nav_bar.dart';
import 'views/pages/video_feed_page.dart';
import 'views/pages/map_search_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'data/dummy_data.dart'; // ✨ 加入這行，就能找到 dummyListings 了

void main() => runApp(const VirtualHomeTourApp());

class VirtualHomeTourApp extends StatelessWidget {
  const VirtualHomeTourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFE0AA3E),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. 初始化 Service
  final NavigationService _navService = NavigationService();

  // 定義頁面
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      VideoFeedPage(listings: dummyListings), // 0: 探索
      MapSearchPage(listings: dummyListings), // 1: 地圖
      const Center(child: Text("工作日誌開發中...")), // 2: 日誌
      const Center(child: Text("個人檔案")),      // 3: 我的
    ];
  }

  @override
  void dispose() {
    _navService.dispose(); // 記得釋放資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 使用 ListenableBuilder 監聽 Service，當 index 改變時切換頁面
    return ListenableBuilder(
      listenable: _navService,
      builder: (context, child) {
        return Scaffold(
          // ✨ 關鍵：允許 Body 延伸到導航列下方，實現「懸浮不遮擋」
          extendBody: false, 
          
          // 使用 IndexedStack 保持頁面狀態 (切換時不會重跑 initState)
          body: IndexedStack(
            index: _navService.currentIndex,
            children: _pages,
          ),
          
          // ✨ 這裡放入我們拆分好的 View
          bottomNavigationBar: FloatingNavBar(service: _navService),
        );
      },
    );
  }
}