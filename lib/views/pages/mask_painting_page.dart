import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MaskPaintingPage extends StatefulWidget {
  final String backgroundImageUrl;

  const MaskPaintingPage({
    super.key, 
    this.backgroundImageUrl = '', 
  });

  @override
  State<MaskPaintingPage> createState() => _MaskPaintingPageState();
}

class _MaskPaintingPageState extends State<MaskPaintingPage> {
  List<Offset?> points = [];
  double strokeWidth = 30.0;

  @override
  Widget build(BuildContext context) {
    // 1. 直接取得螢幕的寬高
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // 改成亮白色背景，確保不是因為太黑看不見
      backgroundColor: Colors.white, 
      
      appBar: AppBar(
        title: const Text("畫布測試", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // 強制藍色 AppBar
      ),
      
      // 2. 這裡不用 Stack，直接給一個有顏色的容器，強迫它撐滿螢幕
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Colors.yellow[100], // 底色是淡黃色 (如果看到黃色，代表畫布存在！)
        
        child: GestureDetector(
          onPanDown: (details) {
            setState(() => points.add(details.localPosition));
          },
          onPanUpdate: (details) {
            setState(() => points.add(details.localPosition));
          },
          onPanEnd: (details) {
            setState(() => points.add(null));
          },
          // 3. 強制 CustomPaint 跟隨容器大小
          child: CustomPaint(
            painter: MaskPainter(
              points: points,
              strokeWidth: strokeWidth,
            ),
            size: Size(screenSize.width, screenSize.height),
          ),
        ),
      ),
      
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Row(
            children: [
              const Icon(Icons.brush, color: Colors.black),
              const SizedBox(width: 10),
              Expanded(
                child: Slider(
                  value: strokeWidth,
                  min: 10.0,
                  max: 100.0,
                  activeColor: Colors.red, // 紅色拉桿
                  onChanged: (val) => setState(() => strokeWidth = val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MaskPainter extends CustomPainter {
  final List<Offset?> points;
  final double strokeWidth;

  MaskPainter({required this.points, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    // 畫筆改成超顯眼的「鮮紅色」
    final paint = Paint()
      ..color = Colors.red 
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(ui.PointMode.points, [points[i]!], paint);
      }
    }
  }

  // 強制重畫
  @override
  bool shouldRepaint(MaskPainter oldDelegate) => true;
}