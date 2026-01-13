import SwiftUI

struct MessageInputBar: View {

    @Binding var text: String
    let onSend: () -> Void

    var body: some View {
        HStack {
            TextField("Mensagem...", text: $text)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(20)

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}
