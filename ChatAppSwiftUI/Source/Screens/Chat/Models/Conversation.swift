import Foundation

struct Conversation: Identifiable {
    let id: String
    let participants: [String]
    let lastMessage: String
    let lastTimestamp: Date
}
