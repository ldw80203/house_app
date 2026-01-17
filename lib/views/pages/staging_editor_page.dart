import 'package:flutter/material.dart';

class StagingEditorPage extends StatefulWidget {
  final String backgroundImageUrl;
  const StagingEditorPage({super.key, required this.backgroundImageUrl});

  @override
  State<StagingEditorPage> createState() => _StagingEditorPageState();
}

class _StagingEditorPageState extends State<StagingEditorPage> {
  // 存放所有被加到畫面上的家具
  List<FurnitureItem> addedFurniture = [];
  
  // 模擬家具清單
  final List<String> furnitureAssets = [
    'https://cdn-icons-png.flaticon.com/512/2663/2663162.png', // 沙發
    'https://cdn-icons-png.flaticon.com/512/1663/1663955.png', // 燈
    'https://cdn-icons-png.flaticon.com/512/751/751630.png',   // 植物
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("虛擬軟裝設計"), backgroundColor: Colors.black),
      body: Column(
        children: [
          // 1. 畫布區域
          Expanded(
            child: InteractiveViewer( // 允許放大縮小整個畫布
              child: Stack(
                children: [
                  // 背景全景圖
                  Positioned.fill(
                    child: Image.network(widget.backgroundImageUrl, fit: BoxFit.cover),
                  ),
                  // 所有已添加的家具
                  ...addedFurniture.map((item) => _buildDraggableFurniture(item)),
                ],
              ),
            ),
          ),
          
          // 2. 底部家具選單
          Container(
            height: 100,
            color: Colors.grey[900],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: furnitureAssets.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 點擊後，新增一個家具到畫面中央
                    setState(() {
                      addedFurniture.add(FurnitureItem(
                        id: DateTime.now().toString(),
                        imageUrl: furnitureAssets[index],
                        position: const Offset(100, 100), // 預設位置
                        scale: 1.0,
                      ));
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Image.network(furnitureAssets[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 建立可拖曳、縮放的家具組件
  Widget _buildDraggableFurniture(FurnitureItem item) {
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        // 拖曳邏輯
        onPanUpdate: (details) {
          setState(() {
            item.position += details.delta;
          });
        },
        // 這裡未來可以加入縮放手勢 (Scale)
        child: Container(
          width: 100 * item.scale, // 基礎寬度 100
          height: 100 * item.scale,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 1), // 選取框
          ),
          child: Image.network(item.imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// 家具的資料模型
class FurnitureItem {
  String id;
  String imageUrl;
  Offset position; // 位置
  double scale;    // 大小

  FurnitureItem({
    required this.id,
    required this.imageUrl,
    required this.position,
    this.scale = 1.0,
  });
}