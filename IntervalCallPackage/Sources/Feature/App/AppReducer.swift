import ComposableArchitecture
import Foundation
import InternalData
import InternalFeatureAds

@Reducer
struct AppReducer: Sendable {
    @ObservableState
    struct State: Equatable {
        public var bannerUnitID: String? = nil
        public var canShowBanner: Bool = false
    }

    enum Action: Sendable {
        case task
        case setupBanner
        case setCanShowBanner(Bool)
    }
    
    @Dependency(\.adsRepository) private var adsRepository: AdsRepository
    @Dependency(\.adMobManager) private var adMobManager: AdMobManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                return .send(.setupBanner)

            case .setupBanner:
                return .concatenate(
                    .run { @MainActor send in
                        /// 必要なユーザ同意を取得する
                        await adMobManager.gatherConsents()
                    },
                    .run { send in
                        /// ハートビートで広告表示可能かを更新する
                        for await value in adMobManager.canRequestAdsStream() {
                            await send(.setCanShowBanner(value))
                        }
                    }
                )

            case let .setCanShowBanner(value):
                state.canShowBanner = value
                return .none
            }
        }
    }
}

