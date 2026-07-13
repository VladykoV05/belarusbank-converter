import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Поиск отделений", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .keyboardDoneButton()
                .overlay(alignment: .leading) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                        .padding(.leading, 8)
                }
                .overlay(alignment: .trailing) {
                    if !text.isEmpty {
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.trailing, 8)
                    }
                }
        }
    }
}
