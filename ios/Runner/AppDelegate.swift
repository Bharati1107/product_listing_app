import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    var filePath: String?

    #if DEV
      filePath = Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")
    #elseif PROD
      filePath = Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")
    #endif

    if let filePath = filePath, 
       let options = FirebaseOptions(contentsOfFile: filePath) {
      FirebaseApp.configure(options: options)
    } else {
      fatalError("Could not find correct GoogleService-Info.plist")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
