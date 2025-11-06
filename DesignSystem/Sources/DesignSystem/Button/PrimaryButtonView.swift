import SwiftUI

public struct PrimaryButtonView: View {
    @Bindable public var viewModel: PrimaryButtonViewModel

    public init(viewModel: PrimaryButtonViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Button(action: {
            viewModel.onTap()
        }) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text(viewModel.model.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        viewModel.isDisabled
                        ? Color.gray
                        : viewModel.model.backgroundColor
                    )
                    .foregroundColor(viewModel.model.textColor)
                    .cornerRadius(viewModel.model.cornerRadius)
                    .opacity(viewModel.isDisabled ? 0.7 : 1.0)
            }
        }
        .disabled(viewModel.isDisabled)
        .animation(.easeInOut, value: viewModel.isLoading)
    }
}
