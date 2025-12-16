import ComposableArchitecture
import Foundation
import InternalData
import InternalFeatureAds
import InternalFeatureIntervalCall

@Reducer
struct AppReducer: Sendable {
    @ObservableState
    struct State: Equatable {
        public var bannerUnitID: String? = nil
        public var canShowBanner: Bool = false
        
        public var intervalCall: IntervalCallReducer.State = .init()
    }

    enum Action: Sendable {
        case task
        case setupBanner
        case setCanShowBanner(Bool)
        
        case intervalCall(IntervalCallReducer.Action)
    }
    
    @Dependency(\.adsRepository) private var adsRepository: AdsRepository
    @Dependency(\.adMobManager) private var adMobManager: AdMobManager

    var body: some ReducerOf<Self> {
        Scope(state: \.intervalCall, action: \.intervalCall) {
            IntervalCallReducer()
        }

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
                
            default:
                return .none
            }
        }
    }
}

