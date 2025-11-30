import ComposableArchitecture
import AVFoundation

public class Speaker: @unchecked Sendable {
    private let synthesizer = AVSpeechSynthesizer()
    
    public func speak(_ utterance: AVSpeechUtterance) {
        synthesizer.speak(utterance)
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
