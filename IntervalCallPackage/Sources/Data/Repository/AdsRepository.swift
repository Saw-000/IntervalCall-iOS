import AppTrackingTransparency
import AdSupport
import ComposableArchitecture
import GoogleMobileAds

@DependencyClient
public struct AdsRepository: Sendable {
    public var admobBannerUnitID: @Sendable () -> String = { "" }
    public var getIDFAWithATTRequestIfNeeded: @Sendable () async -> UUID? = { nil }
}

extension AdsRepository: DependencyKey {
    private enum Const {
        /// テスト用バナーUnit ID（公式サンプル）https://developers.google.com/admob/ios/test-ads?hl=ja#demo_ad_units
        static let debugAdmobBannerUnitID: String = "ca-app-pub-3940256099942544/2435281174"
        /// 本番用バナーUnit ID
        static let productionAdmobBannerUnitID: String = "ca-app-pub-7279710024860495/6673948464"
        
        /// 無効なADFA値(https://developer.apple.com/documentation/adsupport/asidentifiermanager/advertisingidentifier)
        static let invalidADFA: String = "00000000-0000-0000-0000-000000000000"
    }
    
    public static var liveValue: Self {
        .init(
            admobBannerUnitID: {
                #if DEBUG
                return Const.debugAdmobBannerUnitID
                #else
                return Const.productionAdmobBannerUnitID
                #endif
            },
            getIDFAWithATTRequestIfNeeded: {
                let _ = await requestATTPermissionStatus()
                return getIDFA()
            }
        )
    }
}

extension DependencyValues {
    public var adsRepository: AdsRepository {
        get { self[AdsRepository.self] }
        set { self[AdsRepository.self] = newValue }
    }
}

extension AdsRepository {
    /// App Tracking Transparency の許可状態を取得する。まだの時はリクエスト後に返す。
    private static func requestATTPermissionStatus() async -> ATTrackingManager.AuthorizationStatus {
        return await withCheckedContinuation { continuation in
            let status = ATTrackingManager.trackingAuthorizationStatus
            if status != .notDetermined {
                continuation.resume(returning: status)
            } else {
                ATTrackingManager.requestTrackingAuthorization { status in
                    continuation.resume(returning: status)
                }
            }
        }
    }
    
    /// IDFAの取得
    private static func getIDFA() -> UUID? {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier
        
        guard idfa.uuidString != Const.invalidADFA else {
            return nil
        }
        
        return idfa
    }
}
