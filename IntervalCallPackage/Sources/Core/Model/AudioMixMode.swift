import Foundation

public enum AudioMixMode: Sendable {
    case duckOthers     // 他のアプリの音量を下げる
    case mixWithOthers  // 他のアプリの音とミックスする
}
