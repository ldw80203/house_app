import 'package:flutter/material.dart';
import '../../services/navigation_service.dart';

class FloatingNavBar extends StatelessWidget {
  final NavigationService service;

  const FloatingNavBar({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // 深炭灰背景
            // 1. 移除圓角：讓它變成直角填滿
            // borderRadius: const BorderRadius.vertical(top: Radius.circular(30)), 
            
            // 2. 頂部保留一條細線，區隔內容與選單
            border: const Border(
              top: BorderSide(color: Colors.white12, width: 0.5),
            ),
            
            // 3. 調整陰影：讓它看起來比較平整
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            // 4. 壓縮內部留白：原本 vertical 是 12，改成 0 或 5
            child: Container(
              height: 56, // 設定一個標準高度 (通常 Android/iOS 標準是 56~60)
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: service.items.map((item) {
                  final bool isSelected = service.currentIndex == item.id;
                  return _buildNavItem(context, item, isSelected);
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, var item, bool isSelected) {
    return GestureDetector(
      onTap: () => service.setIndex(item.id),
      behavior: HitTestBehavior.opaque,
      child: Container(
        // 增加點擊區域寬度，避免誤觸
        width: 60, 
        padding: const EdgeInsets.symmetric(vertical: 4), // 內部微調
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 垂直置中
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? const Color(0xFFE0AA3E) : Colors.grey[500],
              size: 24, // 圖示稍微縮小一點點 (原本 26)
            ),
            const SizedBox(height: 2), // 文字與圖示距離壓縮 (原本 4)
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10, // 字體縮小 (原本 11)
                color: isSelected ? const Color(0xFFE0AA3E) : Colors.grey[500],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}