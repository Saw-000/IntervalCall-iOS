import ComposableArchitecture
import GoogleMobileAds

@DependencyClient
public struct AdsRepository: Sendable {
    public var admobBannerUnitID: @Sendable () -> String = { "" }
}

extension AdsRepository: DependencyKey {
    private enum Const {
        // テスト用バナーID（公式サンプル）https://developers.google.com/admob/ios/test-ads?hl=ja#demo_ad_units
        static let debugAdmobBannerUnitID: String = "ca-app-pub-3940256099942544/2435281174"
        static let productionAdmobBannerUnitID: String = "本番用バナーID"
    }
    
    public static var liveValue: Self {
        .init(
            admobBannerUnitID: {
                #if DEBUG
                return Const.debugAdmobBannerUnitID
                #else
                return Const.productionAdmobBannerUnitID
                #endif
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
