import SwiftUI
import ComposableArchitecture

/// 間隔で読み上げる機能の画面
public struct IntervalCallView: View {
    @Bindable var store: StoreOf<IntervalCallReducer>

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 読み上げ内容（固定）
                VStack(spacing: 20) {
                    Text(store.displayText)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)

                    if store.isRunning {
                        Text("読み上げ回数: \(store.callCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .background(Color(.systemBackground))

                // 設定（スクロール可能）
                Form {
                    Section("設定") {
                        HStack {
                            Text("読み上げる範囲")
                            Spacer()
                            TextField("", value: $store.startNumber, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 60, height: 36)
                                .padding(.horizontal, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .disabled(store.isRunning)
                            Text("...")
                                .padding(.horizontal, 4)
                            TextField("", value: $store.endNumber, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 60, height: 36)
                                .padding(.horizontal, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .disabled(store.isRunning)
                        }

                        HStack {
                            Text("間隔（秒）")
                            Spacer()
                            TextField("", value: $store.intervalSeconds, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 100, height: 36)
                                .padding(.horizontal, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .disabled(store.isRunning)
                        }

                        HStack {
                            Text("読み上げ回数")
                            Spacer()
                            if let maxCount = store.maxCallCount {
                                TextField("", value: Binding(
                                    get: { maxCount },
                                    set: { store.send(.maxCallCountChanged($0)) }
                                ), format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 100, height: 36)
                                .padding(.horizontal, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .disabled(store.isRunning)
                            } else {
                                Text("エンドレス")
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Toggle("回数を制限する", isOn: Binding(
                            get: { store.maxCallCount != nil },
                            set: { isOn in
                                store.send(.maxCallCountChanged(isOn ? 10 : nil))
                            }
                        ))
                        .disabled(store.isRunning)

                        Toggle("ランダム読み上げ", isOn: $store.isRandomMode)
                            .disabled(store.isRunning)
                    }
                }
                .scrollDismissesKeyboard(.interactively)

                // 開始ボタン（固定）
                VStack {
                    if store.isRunning {
                        Button {
                            store.send(.stopButtonTapped)
                        } label: {
                            Text("停止")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                        }
                    } else {
                        Button {
                            store.send(.startButtonTapped)
                        } label: {
                            Text("開始")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完了") {
                        hideKeyboard()
                    }
                }
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

