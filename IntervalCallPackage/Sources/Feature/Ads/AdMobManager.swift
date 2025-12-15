import ComposableArchitecture
import Foundation
import GoogleMobileAds
import UserMessagingPlatform
import InternalData

/// admob広告関連処理のラッパー
/// 参考 https://github.com/googleads/googleads-mobile-ios-examples/blob/091b24bd88ab41c83fb909793f1b4ef9a5e36aa9/Swift/advanced/SwiftUIDemo/SwiftUIDemo/Supporting-Files/GoogleMobileAdsConsentManager.swift
/// クラス定義自体にMainActorをつけるとTCA Dependencyの設定に引っかかるので、しゃーなし各メンバにつけてる。
final public class AdMobManager: NSObject, @unchecked Sendable {
    /// start()がコールされたか
    @MainActor
    private var isMobileAdsStartCalled: Bool = false

    /// 広告を表示可能か
    @MainActor
    public var canRequestAds: Bool {
        return ConsentInformation.shared.canRequestAds
    }
    
    /// 1秒ごとに canRequestAds を流すストリーム
    public func canRequestAdsStream() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            Task { [weak self] in
                while !Task.isCancelled {
                    guard let self else {
                        continuation.finish()
                        return
                    }

                    continuation.yield(await self.canRequestAds)

                    try? await Task.sleep(for: .seconds(1))
                }
                continuation.finish()
            }
        }
    }

    /// プライバシーオプションの変更導線が必要か
    @MainActor
    public var isPrivacyOptionsRequired: Bool {
        return ConsentInformation.shared.privacyOptionsRequirementStatus == .required
    }

    /// 1秒ごとに isPrivacyOptionsRequired を流すストリーム
    public func isPrivacyOptionsRequiredStream() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            Task { [weak self] in
                while !Task.isCancelled {
                    guard let self else {
                        continuation.finish()
                        return
                    }

                    continuation.yield(await self.isPrivacyOptionsRequired)

                    try? await Task.sleep(for: .seconds(1))
                }
                continuation.finish()
            }
        }
    }
    
    @Dependency(\.adsRepository) private var adsRepository
    
    /// AdMob SDK の初期化。
    /// 一度しか呼ばない。(何回呼んでも内部で弾かれるから安全)
    @MainActor
    public func startAdMobSDK() {
        guard !isMobileAdsStartCalled else { return }

        isMobileAdsStartCalled = true

        MobileAds.shared.start()
    }
    
    /// 必要なユーザ同意を得る
    @MainActor
    public func gatherConsents() async {
        let parameters = RequestParameters()
        
        #if DEBUG
        ConsentInformation.shared.reset()
        let debugSettings = DebugSettings()
        debugSettings.geography = .EEA // .EEA or .regulatedUSState

        parameters.debugSettings = debugSettings
        #endif
        
        do {
            try await ConsentInformation.shared.requestConsentInfoUpdate(with: parameters)
            try await ConsentForm.loadAndPresentIfRequired(from: nil)
        } catch {
        }
    }

    /// プライバシーオプションの設定フォームを開く
    @MainActor
    public func presentPrivacyOptionsForm() async {
        do {
            try await ConsentForm.presentPrivacyOptionsForm(from: nil)
        } catch {
        }
    }
}

extension AdMobManager: DependencyKey {
    // シングルトン
    public static let liveValue = AdMobManager()
}

extension DependencyValues {
    public var adMobManager: AdMobManager {
        get { self[AdMobManager.self] }
        set { self[AdMobManager.self] = newValue }
    }
}
