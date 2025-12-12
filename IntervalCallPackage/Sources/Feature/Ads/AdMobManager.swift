import ComposableArchitecture
import GoogleMobileAds

/// admob広告関連処理のラッパー
public struct AdMobManager: Sendable {
    public var initialize: @Sendable (_ completion: @escaping @Sendable (_ status: InitializationStatus) -> Void) -> Void
}

extension AdMobManager: DependencyKey {
    // シングルトン
    public static let liveValue = AdMobManager(
        initialize: { completion in
            MobileAds.shared.start { @Sendable resultStatus in
                completion(resultStatus)
            }
        }
    )
}

extension DependencyValues {
    public var adMobManager: AdMobManager {
        get { self[AdMobManager.self] }
        set { self[AdMobManager.self] = newValue }
    }
}

