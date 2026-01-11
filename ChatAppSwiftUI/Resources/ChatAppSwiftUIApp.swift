import SwiftUI

@main
struct ChatAppSwiftUIApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    var body: some Scene {
        WindowGroup {
            ChatView()
        }
    }
}
