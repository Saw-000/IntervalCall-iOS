import SwiftUI
import InternalFeatureApp

@main
struct IntervalCallApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
