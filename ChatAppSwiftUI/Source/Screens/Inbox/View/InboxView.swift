import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct InboxView: View {

    @StateObject private var viewModel = InboxViewModel()
    @State private var newConversationId: String?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.conversations) { conversation in
                    NavigationLink {
                        ChatView(conversationId: conversation.id)
                    } label: {
                        Text(conversation.lastMessage)
                    }
                }
                .onDelete(perform: deleteConversation)
            }
            .navigationTitle("Conversas")
            .toolbar {
                Button {
                    createConversation()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
            .navigationDestination(item: $newConversationId) { id in
                ChatView(conversationId: id)
            }
        }
    }

    private func deleteConversation(at offsets: IndexSet) {
        offsets.forEach { index in
            let conversation = viewModel.conversations[index]
            viewModel.deleteConversation(conversation)
        }
    }

    private func createConversation() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let doc = Firestore.firestore().collection("conversations").document()

        doc.setData([
            "participants": [userId],
            "lastMessage": "",
            "lastTimestamp": Timestamp()
        ])

        newConversationId = doc.documentID
    }
}
