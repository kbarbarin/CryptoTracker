import SwiftUI

public struct ProfitBadgeView: View {
    @Bindable var viewModel: ProfitBadgeViewModel
    
    public init(viewModel: ProfitBadgeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: viewModel.iconName)
                .font(.system(size: 12, weight: .bold))
            
            Text(viewModel.model.value)
                .font(AppFont.percentage)
        }
        .foregroundStyle(
            viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(
                    (viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed)
                        .opacity(0.15)
                )
        )
    }
}

