import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart'; // 新增：分享功能
import 'package:url_launcher/url_launcher.dart'; // 新增：撥號功能
import '../../models/property_model.dart';
import 'mask_painting_page.dart'; // 假設你之前的塗抹頁面叫這個

class VideoFeedPage extends StatefulWidget {
  final List<PropertyListing> listings;

  const VideoFeedPage({super.key, required this.listings});

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // 延伸 Body 讓影片沉浸式顯示 (如果你的 Main 有設定 extendBody 這裡就不用擔心)
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.listings.length,
        itemBuilder: (context, index) {
          return VideoItem(listing: widget.listings[index]);
        },
      ),
    );
  }
}

// 將單個影片項目獨立出來，方便管理狀態 (例如按讚)
class VideoItem extends StatefulWidget {
  final PropertyListing listing;

  const VideoItem({super.key, required this.listing});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  
  // ✨ 本地狀態：記錄使用者互動
  bool _isLiked = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.listing.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 📞 功能：聯絡房仲 (底部彈窗)
  void _showContactPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("聯絡專屬經紀人", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text("撥打電話", style: TextStyle(color: Colors.white)),
                subtitle: const Text("0912-345-678", style: TextStyle(color: Colors.grey)),
                onTap: () {
                   Navigator.pop(context);
                   launchUrl(Uri.parse("tel:0912345678")); // 撥號
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble, color: Colors.green), // LINE 綠色
                title: const Text("加 LINE 預約", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // 這裡填入你的 LINE 連結
                  launchUrl(Uri.parse("https://line.me/ti/p/your_id")); 
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✈️ 功能：分享物件
  void _shareProperty() {
    Share.share(
      '🔥 發現一個超讚的物件！\n\n【${widget.listing.title}】\n總價：${widget.listing.price}\n位置：${widget.listing.location}\n\n快下載 House App 查看詳情！',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. 影片層
        GestureDetector(
          onTap: () {
            // 點擊螢幕暫停/播放
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: _isInitialized
              ? VideoPlayer(_controller)
              : const Center(child: CircularProgressIndicator(color: Color(0xFFE0AA3E))),
        ),

        // 2. 漸層遮罩 (讓文字更清楚)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black12,
                Colors.transparent,
                Colors.black54, // 底部加深
                Colors.black87,
              ],
            ),
          ),
        ),

        // 3. 右側互動按鈕列
        Positioned(
          right: 16,
          bottom: 100, // 避開底部導航列的高度
          child: Column(
            children: [
              // 頭像 (聯絡按鈕)
              GestureDetector(
                onTap: _showContactPanel, // ✨ 點擊跳出聯絡選單
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE0AA3E), width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // 你的頭像
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 愛心 (按讚)
              _buildActionButton(
                icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.white,
                label: "1.2k",
                onTap: () => setState(() => _isLiked = !_isLiked), // ✨ 切換狀態
              ),

              // 收藏
              _buildActionButton(
                icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: _isSaved ? const Color(0xFFE0AA3E) : Colors.white,
                label: "收藏",
                onTap: () => setState(() => _isSaved = !_isSaved), // ✨ 切換狀態
              ),

              // 分享
              _buildActionButton(
                icon: Icons.share,
                color: Colors.white,
                label: "分享",
                onTap: _shareProperty, // ✨ 呼叫分享
              ),

              // AR 裝潢入口
              _buildActionButton(
                icon: Icons.view_in_ar,
                color: Colors.white,
                label: "裝潢",
                onTap: () {
                   // 暫時跳轉到塗抹頁面，或顯示「開發中」
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (_) => const MaskPaintingPage()),
                   );
                },
              ),
            ],
          ),
        ),

        // 4. 左下角資訊卡
        Positioned(
          left: 20,
          bottom: 100,
          right: 100, // 留空間給右邊按鈕
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 房型標籤
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0AA3E).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.listing.specs,
                  style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              // 價格
              Text(
                widget.listing.price,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              // 社區名稱
              Text(
                widget.listing.title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 4),
              // 地點 (點擊可以導航)
              GestureDetector(
                onTap: () {
                  // TODO: 之後這裡要串接到 MapSearchPage 並定位
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("正在前往：${widget.listing.location}"))
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFE0AA3E), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.listing.address,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 封裝按鈕樣式
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4), // 半透明背景讓按鈕更清楚
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}