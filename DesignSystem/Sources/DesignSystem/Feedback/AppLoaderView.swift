import SwiftUI

public struct AppLoaderView: View {
    @State private var isAnimating = false
    
    public init() {}
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                AppColor.accentGreen,
                style: StrokeStyle(lineWidth: 4, lineCap: .round)
            )
            .frame(width: 40, height: 40)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(
                    .linear(duration: 1)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}

public struct LoadingOverlay: View {
    let message: String
    
    public init(message: String = "Chargement...") {
        self.message = message
    }
    
    public var body: some View {
        ZStack {
            AppColor.backgroundPrimary.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                AppLoaderView()
                
                Text(message)
                    .font(AppFont.body)
                    .foregroundStyle(AppColor.textPrimary)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColor.cardBackground)
            )
        }
    }
}

