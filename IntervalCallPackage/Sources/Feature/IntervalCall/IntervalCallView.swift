import SwiftUI
import ComposableArchitecture

/// 間隔で読み上げる機能の画面
public struct IntervalCallView: View {
    @Bindable var store: StoreOf<IntervalCallReducer>
    
    public var body: some View {
        Text("IntervalCallView")
    }
    
    public init(store: StoreOf<IntervalCallReducer>) {
        self.store = store
    }
}

// MARK: - Preview

#Preview {
    IntervalCallView(
        store: Store(initialState: .init()) { IntervalCallReducer() }
    )
}

