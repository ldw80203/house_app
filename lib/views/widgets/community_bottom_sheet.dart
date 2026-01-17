import 'package:flutter/material.dart';
import '../../models/property_model.dart';

class CommunityBottomSheet extends StatelessWidget {
  final String title;
  final List<PropertyListing> listings;
  final ScrollController scrollController;

  const CommunityBottomSheet({
    super.key,
    required this.title,
    required this.listings,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // 把手
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20, top: 10),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 標題列
          Row(
            children: [
              const Icon(Icons.location_city, color: Color(0xFFE0AA3E)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "${listings.length} 間待售",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Divider(color: Colors.white12, height: 30),
          // 列表
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              itemCount: listings.length,
              separatorBuilder: (ctx, i) => const Divider(color: Colors.white12),
              itemBuilder: (context, index) {
                final house = listings[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[800],
                      child: const Icon(Icons.home, color: Colors.white54),
                    ),
                  ),
                  title: Text(
                    house.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(house.specs, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(house.price, style: const TextStyle(color: Color(0xFFE0AA3E), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                  onTap: () => Navigator.pop(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}