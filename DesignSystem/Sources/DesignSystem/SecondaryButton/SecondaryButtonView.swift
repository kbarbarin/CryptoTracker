import SwiftUI

public struct SecondaryButtonView: View {
    @Bindable var viewModel: SecondaryButtonViewModel
    
    public init(viewModel: SecondaryButtonViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Button(action: viewModel.action) {
            Text(viewModel.model.title)
                .font(AppFont.body)
                .foregroundStyle(AppColor.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColor.textSecondary, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }
}

