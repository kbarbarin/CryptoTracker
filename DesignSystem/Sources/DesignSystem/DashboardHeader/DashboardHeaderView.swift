import SwiftUI

public struct DashboardHeaderView: View {
    @Bindable var viewModel: DashboardHeaderViewModel
    
    public init(viewModel: DashboardHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            // Titre
            Text("Solde Total")
                .font(AppFont.label)
                .foregroundStyle(AppColor.textSecondary)
            
            // Balance principale
            Text(viewModel.model.balance)
                .font(AppFont.title)
                .foregroundStyle(AppColor.textPrimary)
            
            // Variation
            HStack(spacing: 8) {
                Text(viewModel.model.change)
                    .font(AppFont.body)
                    .foregroundStyle(
                        viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed
                    )
                
                ProfitBadgeView(viewModel: viewModel.profitBadgeViewModel)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
}

