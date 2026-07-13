import SwiftUI

extension View {
    func keyboardDoneButton() -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Готово") {
                    UIApplication.shared.endEditing()
                }
                .font(.headline)
            }
        }
    }
}
