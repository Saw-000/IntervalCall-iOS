import ComposableArchitecture
import UIKit
import InternalFeatureAds

/// このアプリのデリゲート
public final class AppDelegate: NSObject, UIApplicationDelegate {
    @Dependency(\.adMobManager) private var adMobManager: AdMobManager
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        adMobManager.startAdMobSDK()

        return true
    }
}

