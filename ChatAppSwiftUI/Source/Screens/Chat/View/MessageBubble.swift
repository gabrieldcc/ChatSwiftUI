import SwiftUI

struct MessageBubble: View {

    let message: Message
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }

            Text(message.text)
                .padding(12)
                .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isCurrentUser ? .white : .black)
                .cornerRadius(16)

            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}
