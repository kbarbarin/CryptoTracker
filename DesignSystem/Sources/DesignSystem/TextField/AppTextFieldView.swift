import SwiftUI

public struct AppTextFieldView: View {
    @Bindable public var viewModel: AppTextFieldViewModel

    public init(viewModel: AppTextFieldViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            if viewModel.model.isSecure {
                SecureField(viewModel.model.placeholder, text: $viewModel.text)
            } else {
                TextField(viewModel.model.placeholder, text: $viewModel.text)
                    .keyboardType(viewModel.model.keyboardType)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
