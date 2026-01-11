import SwiftUI

struct ChatView: View {

    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText: String = ""

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(
                                message: message,
                                isCurrentUser: message.senderId == viewModel.currentUserId
                            )
                            .id(message.id)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            MessageInputBar(text: $messageText) {
                guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                viewModel.sendMessage(text: messageText)
                messageText = ""
            }
        }
        .navigationTitle("Chat")
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
