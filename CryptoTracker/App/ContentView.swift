import SwiftUI
import DesignSystem

struct ContentView: View {
    @State private var textVM = AppTextFieldViewModel(
        model: AppTextFieldModel(placeholder: "Montant en €")
    )

    var body: some View {
        VStack(spacing: 16) {
            AppTextFieldView(viewModel: textVM)
            PrimaryButtonView(
                viewModel: PrimaryButtonViewModel(
                    model: PrimaryButtonModel(title: "Acheter BTC"),
                    action: { print("Montant saisi :", textVM.text) }
                )
            )
        }
        .padding()
    }
}

