import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBiq3ZaMSZkxInC04BFG_aT9o0Zh6QUBSw")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
