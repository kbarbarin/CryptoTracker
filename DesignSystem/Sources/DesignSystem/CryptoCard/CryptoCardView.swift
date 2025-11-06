import SwiftUI

public struct CryptoCardView: View {
    @Bindable var viewModel: CryptoCardViewModel
    
    public init(viewModel: CryptoCardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Button(action: viewModel.action) {
            HStack(spacing: 16) {
                // Icône crypto avec image
                AsyncImage(url: URL(string: viewModel.model.imageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(AppColor.accentYellow.opacity(0.2))
                            .frame(width: 48, height: 48)
                            .overlay(
                                ProgressView()
                                    .tint(AppColor.accentYellow)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                    case .failure:
                        Circle()
                            .fill(AppColor.accentYellow.opacity(0.2))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Text(viewModel.iconLetter)
                                    .font(AppFont.subtitle)
                                    .foregroundStyle(AppColor.accentYellow)
                            )
                    @unknown default:
                        Circle()
                            .fill(AppColor.accentYellow.opacity(0.2))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Text(viewModel.iconLetter)
                                    .font(AppFont.subtitle)
                                    .foregroundStyle(AppColor.accentYellow)
                            )
                    }
                }
                
                // Info crypto
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.model.symbol)
                        .font(AppFont.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColor.textPrimary)
                    
                    Text(viewModel.model.name)
                        .font(AppFont.label)
                        .foregroundStyle(AppColor.textSecondary)
                }
                
                Spacer()
                
                // Prix et variation
                VStack(alignment: .trailing, spacing: 4) {
                    Text(viewModel.model.price)
                        .font(AppFont.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColor.textPrimary)
                    
                    Text(viewModel.model.change)
                        .font(AppFont.percentage)
                        .foregroundStyle(
                            viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed
                        )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColor.cardBackground)
            )
        }
        .buttonStyle(.plain)
    }
}

