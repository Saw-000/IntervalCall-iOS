import SwiftUI
import ComposableArchitecture
import InternalFeatureAds
import InternalFeatureIntervalCall

public struct AppView: View {
    @Bindable var store = Store(initialState: .init()) { AppReducer() }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                // 本画面
                IntervalCallView(store: Store(initialState: .init()) { IntervalCallReducer() })

                // バナー広告
                if store.canShowBanner {
                    AnchoredAdaptiveBannerView(width: geometry.size.width)
                }
            }
        }
        .task {
            store.send(.task)
        }
    }
    
    public init() {}
}

// MARK: - Preview

#Preview {
    AppView()
}

