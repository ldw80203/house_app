import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AiStagingService {
  // 注意：實際發布時，這個 Key 應該放在後端伺服器，不要直接寫在 APP 裡，以免被盜用。
  // 但開發階段我們可以先這樣寫。你需要去 replicate.com 申請一個 API Token。
  final String _apiKey = 'YOUR_REPLICATE_API_TOKEN';

  // 這就是「魔法」發生的函式
  Future<String?> generateNewFurniture({
    required String originalImageUrl, // 原始房間圖
    required String maskImageUrl,     // 遮罩圖 (告訴 AI 哪裡要改)
    required String prompt,           // 提示詞 (例如: "Modern white fabric sofa")
  }) async {
    
    // 1. 設定我們要用的 AI 模型 (這裡使用 Stable Diffusion Inpainting)
    // 這是目前官方推薦的穩定版本
    const String modelVersion = "stability-ai/stable-diffusion-inpainting:c28b92a7ecd66eee8aabc98fb96361308948d251d8d6766422b403478e79207a";
    const String apiUrl = "https://api.replicate.com/v1/predictions";

    // 2. 準備要寄給 AI 的包裹 (Header & Body)
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Token $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "version": modelVersion,
          "input": {
            "image": originalImageUrl, // 原始圖
            "mask": maskImageUrl,      // 黑白遮罩圖 (白色=要改的地方, 黑色=保留)
            "prompt": "$prompt, high quality, realistic, 4k, interior design", // 加強提示詞
            "negative_prompt": "low quality, blurry, bad anatomy, worst quality", // 負面提示詞(不要出現的東西)
            "num_inference_steps": 30, // AI 思考的步數 (越多越細緻，但也越慢)
            "guidance_scale": 7.5,
          }
        }),
      );

      if (response.statusCode == 201) {
        // 3. 成功送出指令！開始輪詢 (Polling) 等待結果
        // 因為 AI 生成需要 5-10 秒，我們不能馬上拿到圖片，要拿著「收據 ID」去問好了沒
        final responseData = jsonDecode(response.body);
        final String getResultUrl = responseData['urls']['get'];
        
        return await _waitForResult(getResultUrl);
      } else {
        print("API 請求失敗: ${response.body}");
        return null;
      }
    } catch (e) {
      print("發生錯誤: $e");
      return null;
    }
  }

  //這是一個「每隔一秒去問一次好了沒」的函式
  Future<String?> _waitForResult(String url) async {
    while (true) {
      await Future.delayed(const Duration(seconds: 2)); // 等 2 秒
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Token $_apiKey'},
      );

      final data = jsonDecode(response.body);
      final String status = data['status'];

      if (status == 'succeeded') {
        // 成功！回傳新圖片的網址
        return data['output'][0]; 
      } else if (status == 'failed') {
        print("AI 生成失敗");
        return null;
      }
      // 如果是 'processing' 或 'starting'，就繼續迴圈等待
    }
  }
}