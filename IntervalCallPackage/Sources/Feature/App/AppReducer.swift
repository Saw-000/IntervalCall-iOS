import SwiftUI
import ComposableArchitecture

@Reducer
struct AppReducer: Sendable {
    @ObservableState
    struct State: Equatable {
    }

    enum Action: Sendable {
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

