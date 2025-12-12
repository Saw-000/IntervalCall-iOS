import ComposableArchitecture
import InternalData

@Reducer
struct AppReducer: Sendable {
    @ObservableState
    struct State: Equatable {
        public var bannerUnitID: String? = nil
    }

    enum Action: Sendable {
        case task
    }
    
    @Dependency(\.adsRepository) private var adsRepository: AdsRepository

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                state.bannerUnitID = adsRepository.admobBannerUnitID()
                return .none
            }
        }
    }
}

