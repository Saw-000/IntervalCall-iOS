import ComposableArchitecture
import AVFoundation

public class Speaker: @unchecked Sendable {
    private let synthesizer = AVSpeechSynthesizer()
    
    init() {
        activateAudioSession()
    }
    
    deinit {
        deactivateAudioSession()
    }
    
    public func speak(_ utterance: AVSpeechUtterance) {
        synthesizer.speak(utterance)
    }
    
    /// AudioSessionを有効化
    private func activateAudioSession() {
        let sess = AVAudioSession.sharedInstance()
        try? sess.setActive(false) // 念の為
        try? sess.setCategory(.playback)
        try? sess.setActive(true)
    }
    
    /// AudioSessionを無効化
    private func deactivateAudioSession() {
        let sess = AVAudioSession.sharedInstance()
        try? sess.setActive(false, options: .notifyOthersOnDeactivation)
    }
}

extension Speaker: DependencyKey {
    // シングルトン
    public static let liveValue = Speaker()
}

extension DependencyValues {
    public var speaker: Speaker {
        get { self[Speaker.self] }
        set { self[Speaker.self] = newValue }
    }
}
