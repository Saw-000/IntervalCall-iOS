import ComposableArchitecture
import InternalData
import Foundation

@Reducer
struct AppReducer: Sendable {
    @ObservableState
    struct State: Equatable {
        public var bannerUnitID: String? = nil
    }

    enum Action: Sendable {
        case task
        case setupBanner
        case setBannerUnitID(String)
    }
    
    @Dependency(\.adsRepository) private var adsRepository: AdsRepository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                return .send(.setupBanner)

            case .setupBanner:
                return .run { @MainActor send in
                    // ATTの権限申請
                    let _ = await adsRepository.getIDFAWithATTRequestIfNeeded()
                    // APP Unit ID の取得
                    send(.setBannerUnitID(adsRepository.admobBannerUnitID()))
                }
                
            case let .setBannerUnitID(id):
                state.bannerUnitID = id
                return .none
            }
        }
    }
}

