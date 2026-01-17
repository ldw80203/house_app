import 'package:flutter/material.dart';
import '../../core/app_constants.dart';

class VirtualStagingPage extends StatefulWidget {
  const VirtualStagingPage({super.key});

  @override
  State<VirtualStagingPage> createState() => _VirtualStagingPageState();
}

class _VirtualStagingPageState extends State<VirtualStagingPage> {
  // 目前選擇的裝潢風格索引
  int _selectedStyleIndex = 0;

  // 模擬 AI 生成的裝潢圖片路徑 (實際開發時會從 API 獲取)
  final List<String> _stagingImages = [
    'https://images.unsplash.com/photo-1584622050111-993a426fbf0a?q=80&w=800&auto=format&fit=crop', // 原始空屋
    'https://images.unsplash.com/photo-1595558013260-53aed9d010e9?q=80&w=800&auto=format&fit=crop', // 北歐極簡
    'https://images.unsplash.com/photo-1600607686527-6fb886090705?q=80&w=800&auto=format&fit=crop', // 現代工業
  ];

  final List<String> _styleNames = ["原始屋況", "北歐極簡", "現代工業"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 讓圖片延伸到狀態欄後方，增加沈浸感
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text(AppStrings.staging, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 上半部：大型圖片展示區
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image.network(
                      _stagingImages[_selectedStyleIndex],
                      key: ValueKey<int>(_selectedStyleIndex),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(color: AppColors.gold));
                      },
                    ),
                  ),
                ),
                // 右上角當前模式標籤
                Positioned(
                  top: 100,
                  right: 20,
                  child: _buildCurrentStyleTag(),
                )
              ],
            ),
          ),

          // 下半部：風格選擇控制台
          _buildStyleSelector(),
        ],
      ),
    );
  }

  // 當前風格標籤
  Widget _buildCurrentStyleTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.white.withOpacity(0.3)),
      ),
      child: Text(
        "目前模式：${_styleNames[_selectedStyleIndex]}",
        style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  // 底部風格選擇器
  Widget _buildStyleSelector() {
    return Container(
      height: 180,
      color: const Color(0xFF1E1E1E), // 稍微淺一點的深色，與底色區分
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "選擇裝潢風格",
            style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_styleNames.length, (index) {
              bool isSelected = _selectedStyleIndex == index;
              return _buildStyleThumb(index, isSelected);
            }),
          ),
        ],
      ),
    );
  }

  // 單一風格縮圖按鈕
  Widget _buildStyleThumb(int index, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedStyleIndex = index),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: AppColors.gold, width: 2) : null,
              boxShadow: isSelected ? [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 8)] : null,
              image: DecorationImage(
                image: NetworkImage(_stagingImages[index]),
                fit: BoxFit.cover,
                opacity: isSelected ? 1.0 : 0.5,
              ),
            ),
            child: isSelected 
                ? const Icon(Icons.check_circle, color: AppColors.gold, size: 24) 
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            _styleNames[index],
            style: TextStyle(
              color: isSelected ? AppColors.gold : AppColors.greyText,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}