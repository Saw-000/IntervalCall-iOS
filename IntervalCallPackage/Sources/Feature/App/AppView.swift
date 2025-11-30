import SwiftUI
import ComposableArchitecture
import InternalFeatureIntervalCall

public struct AppView: View {
    @Bindable var store = Store(initialState: .init()) { AppReducer() }
    
    public var body: some View {
        IntervalCallView(store: Store(initialState: .init()) { IntervalCallReducer() })
    }
    
    public init() {}
}

// MARK: - Preview

#Preview {
    AppView()
}

