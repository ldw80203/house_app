import UIKit
import Flutter
import GoogleMaps // 1. 引入 Google Maps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 2. 在這裡註冊你的 API Key (非常重要，沒這行會閃退)
    GMSServices.provideAPIKey("AIzaSyCD7BJq7y3CAYnv2w6dBCVLGMuzQp-gxTw") 

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}