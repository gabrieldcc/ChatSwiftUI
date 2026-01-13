import FirebaseFirestore
import FirebaseAuth

final class ChatViewModel: ObservableObject {

    @Published var messages: [Message] = []

    private let db = Firestore.firestore()
    private let collectionName = "messages"
    private var listener: ListenerRegistration?
    let conversationId: String

    var currentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    init(conversationId: String) {
        self.conversationId = conversationId
        listenForMessages()
    }


    private func listenForMessages() {
        listener = db.collection(collectionName)
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, _ in

                guard let documents = snapshot?.documents else { return }

                let newMessages = documents.compactMap { doc -> Message? in
                    let data = doc.data()

                    guard
                        let text = data["text"] as? String,
                        let senderId = data["senderId"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp
                    else { return nil }

                    return Message(
                        id: doc.documentID,
                        text: text,
                        senderId: senderId,
                        timestamp: timestamp.dateValue()
                    )
                }

                DispatchQueue.main.async {
                    self.messages = newMessages
                }
            }
    }


//    func sendMessage(text: String) {
//        let data: [String: Any] = [
//            "text": text,
//            "senderId": currentUserId,
//            "timestamp": Timestamp()
//        ]
//
//        db.collection(collectionName).addDocument(data: data)
//    }
    
    func sendMessage(text: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let messageData: [String: Any] = [
            "text": text,
            "senderId": userId,
            "timestamp": Timestamp()
        ]

        let conversationRef = db.collection("conversations").document(conversationId)

        // 1️⃣ Salva mensagem
        conversationRef
            .collection("messages")
            .addDocument(data: messageData)

        // 2️⃣ Atualiza inbox
        conversationRef.setData([
            "participants": [userId], // por enquanto só um
            "lastMessage": text,
            "lastTimestamp": Timestamp()
        ], merge: true)
    }


    deinit {
        listener?.remove()
    }
}
