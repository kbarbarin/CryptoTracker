import SwiftUI

public struct AmountInputView: View {
    @Bindable var viewModel: AmountInputViewModel
    
    public init(viewModel: AmountInputViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            TextField(viewModel.model.placeholder, text: $viewModel.text)
                .font(AppFont.subtitle)
                .foregroundStyle(AppColor.textPrimary)
                .keyboardType(viewModel.model.keyboardType)
                .padding(.vertical, 16)
            
            Text(viewModel.model.symbol)
                .font(AppFont.body)
                .foregroundStyle(AppColor.textSecondary)
                .padding(.trailing, 8)
        }
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    viewModel.text.isEmpty ? AppColor.textSecondary.opacity(0.3) : AppColor.accentGreen,
                    lineWidth: 1.5
                )
        )
    }
}

