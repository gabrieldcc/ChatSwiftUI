import SwiftUI
import FirebaseAuth

struct RootView: View {

    var body: some View {
        if Auth.auth().currentUser != nil {
            InboxView()
        } else {
            ProgressView("Entrando...")
        }
    }
}
