import FirebaseFirestore
import FirebaseAuth

final class InboxViewModel: ObservableObject {

    @Published var conversations: [Conversation] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    private var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    init() {
        listenForConversations()
    }
    
    func deleteConversation(_ conversation: Conversation) {
        Firestore.firestore()
            .collection("conversations")
            .document(conversation.id)
            .delete()
    }


    private func listenForConversations() {
        listener = db.collection("conversations")
            .whereField("participants", arrayContains: currentUserId)
            .order(by: "lastTimestamp", descending: true)
            .addSnapshotListener { snapshot, _ in

                guard let documents = snapshot?.documents else { return }

                let newConversations = documents.compactMap { doc -> Conversation? in
                    let data = doc.data()

                    guard
                        let participants = data["participants"] as? [String],
                        let lastMessage = data["lastMessage"] as? String,
                        let lastTimestamp = data["lastTimestamp"] as? Timestamp
                    else { return nil }

                    return Conversation(
                        id: doc.documentID,
                        participants: participants,
                        lastMessage: lastMessage,
                        lastTimestamp: lastTimestamp.dateValue()
                    )
                }

                DispatchQueue.main.async {
                    self.conversations = newConversations
                }
            }
    }
}
