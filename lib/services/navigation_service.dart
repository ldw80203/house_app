import 'package:flutter/material.dart';
import '../models/nav_item_model.dart';

class NavigationService extends ChangeNotifier {
  // 內部變數：當前頁面索引
  int _currentIndex = 0;

  // 公開讀取器
  int get currentIndex => _currentIndex;

  // 定義所有選單項目 (集中管理，方便修改)
  final List<NavItemModel> items = [
    const NavItemModel(id: 0, label: "探索", icon: Icons.play_circle_outline, activeIcon: Icons.play_circle_fill),
    const NavItemModel(id: 1, label: "地圖", icon: Icons.map_outlined, activeIcon: Icons.map),
    const NavItemModel(id: 2, label: "日誌", icon: Icons.assignment_outlined, activeIcon: Icons.assignment),
    const NavItemModel(id: 3, label: "我的", icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  // 修改頁面的方法
  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      // 通知所有訂閱者 (View) 更新畫面
      notifyListeners();
    }
  }
}