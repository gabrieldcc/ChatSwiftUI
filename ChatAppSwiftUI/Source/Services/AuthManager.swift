import FirebaseAuth

final class AuthManager {

    static let shared = AuthManager()
    private init() {}

    func signInAnonymously() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    print("Auth error:", error.localizedDescription)
                } else {
                    print("Logged in with uid:", result?.user.uid ?? "")
                }
            }
        }
    }
}
