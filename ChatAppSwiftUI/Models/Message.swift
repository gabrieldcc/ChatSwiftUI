import FirebaseFirestore

struct Message: Identifiable {
    let id: String
    let text: String
    let senderId: String
    let timestamp: Date
}
