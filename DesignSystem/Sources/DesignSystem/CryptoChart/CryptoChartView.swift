import SwiftUI
import Charts

public struct CryptoChartView: View {
    @Bindable var viewModel: CryptoChartViewModel
    
    public init(viewModel: CryptoChartViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Chart(viewModel.chartData) { dataPoint in
            LineMark(
                x: .value("Jour", dataPoint.day),
                y: .value("Prix", dataPoint.price)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed,
                        (viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed)
                            .opacity(0.5)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            AreaMark(
                x: .value("Jour", dataPoint.day),
                y: .value("Prix", dataPoint.price)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        (viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed)
                            .opacity(0.3),
                        (viewModel.model.isPositive ? AppColor.accentGreen : AppColor.accentRed)
                            .opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 200)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.cardBackground)
        )
    }
}

