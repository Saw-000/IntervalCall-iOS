import SwiftUI
import ComposableArchitecture

@Reducer
public struct IntervalCallReducer: Sendable {
    @ObservableState
    public struct State: Equatable {
        
        public init() {}
    }

    public enum Action: Sendable {
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
    
    public init() {}
}

