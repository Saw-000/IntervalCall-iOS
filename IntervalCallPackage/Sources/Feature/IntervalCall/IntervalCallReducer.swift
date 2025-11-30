import SwiftUI
import ComposableArchitecture
import AVFoundation
import InternalCore

@Reducer
public struct IntervalCallReducer: Sendable {
    @ObservableState
    public struct State: Equatable {
        // 設定値
        public var startNumber: Int = 1
        public var endNumber: Int = 10
        public var intervalSeconds: Double = 1.0
        public var maxCallCount: Int? = nil  // nilの場合はエンドレス
        public var isRandomMode: Bool = true  // ランダムモード

        // 状態
        public var isRunning: Bool = false
        public var currentNumber: Int? = nil
        public var callCount: Int = 0
        public var displayText: String = "準備完了"



        public init() {}
    }

    public enum Action: Sendable, BindableAction {
        case startNumberChanged(Int)
        case endNumberChanged(Int)
        case intervalSecondsChanged(Double)
        case maxCallCountChanged(Int?)

        case startButtonTapped
        case stopButtonTapped
        case tick
        case speak(Int)
        case speakCompleted
        case binding(BindingAction<State>)
    }

    @Dependency(\.speaker) var speaker: Speaker
    @Dependency(\.continuousClock) var clock
    private enum CancelID { case timer }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .startNumberChanged(let value):
                state.startNumber = value
                return .none

            case .endNumberChanged(let value):
                state.endNumber = value
                return .none

            case .intervalSecondsChanged(let value):
                state.intervalSeconds = value
                return .none

            case .maxCallCountChanged(let value):
                state.maxCallCount = value
                return .none

            case .startButtonTapped:
                state.isRunning = true
                state.currentNumber = state.startNumber
                state.callCount = 0
                return .send(.tick)

            case .stopButtonTapped:
                state.isRunning = false
                state.currentNumber = nil
                state.displayText = "停止しました"
                return .cancel(id: CancelID.timer)

            case .tick:
                guard state.isRunning else { return .none }

                // 最大回数チェック
                if let maxCount = state.maxCallCount, state.callCount >= maxCount {
                    state.isRunning = false
                    state.displayText = "完了しました"
                    return .none
                }

                guard let current = state.currentNumber else { return .none }
                let interval = state.intervalSeconds

                return .run { send in
                    await send(.speak(current))
                    try await clock.sleep(for: .seconds(interval))
                    await send(.speakCompleted)
                }
                .cancellable(id: CancelID.timer)

            case .speak(let number):
                state.displayText = "\(number)"
                state.callCount += 1

                // 実際の読み上げはEffectで処理
                return .run { @MainActor _ in
                    let utterance = AVSpeechUtterance(string: "\(number)")
                    utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
                    utterance.rate = 0.5

                    speaker.speak(utterance)
                }

            case .speakCompleted:
                guard state.isRunning else { return .none }
                guard let current = state.currentNumber else { return .none }

                // 次の数字を計算
                let nextNumber: Int
                if state.isRandomMode {
                    // ランダムモード：範囲内からランダムに選択
                    nextNumber = Int.random(in: state.startNumber...state.endNumber)
                } else {
                    // 順次モード：次の数字に進む
                    var next = current + 1
                    if next > state.endNumber {
                        next = state.startNumber  // 最初に戻る
                    }
                    nextNumber = next
                }
                state.currentNumber = nextNumber

                return .send(.tick)

            case .binding:
                return .none
            }
        }
    }

    public init() {}
}

