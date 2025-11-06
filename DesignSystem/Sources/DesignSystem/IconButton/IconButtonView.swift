import SwiftUI

public struct IconButtonView: View {
    @Bindable var viewModel: IconButtonViewModel
    
    public init(viewModel: IconButtonViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Button(action: viewModel.action) {
            Image(systemName: viewModel.model.iconName)
                .font(.system(size: viewModel.model.size))
                .foregroundStyle(AppColor.textPrimary)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(AppColor.cardBackground)
                )
        }
        .buttonStyle(.plain)
    }
}

