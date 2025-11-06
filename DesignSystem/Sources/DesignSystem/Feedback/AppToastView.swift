import SwiftUI

public enum ToastType {
    case success
    case error
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return AppColor.accentGreen
        case .error: return AppColor.accentRed
        case .info: return AppColor.accentYellow
        }
    }
}

public struct AppToastModel {
    public let message: String
    public let type: ToastType
    
    public init(message: String, type: ToastType) {
        self.message = message
        self.type = type
    }
}

@Observable
public final class AppToastViewModel {
    public var isShowing: Bool = false
    public var model: AppToastModel?
    
    public init() {}
    
    public func show(message: String, type: ToastType) {
        model = AppToastModel(message: message, type: type)
        withAnimation(.easeInOut(duration: 0.25)) {
            isShowing = true
        }
        
        // Auto-dismiss après 3 secondes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss()
        }
    }
    
    public func dismiss() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isShowing = false
        }
    }
}

public struct AppToastView: View {
    @Bindable var viewModel: AppToastViewModel
    
    public init(viewModel: AppToastViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        if viewModel.isShowing, let model = viewModel.model {
            HStack(spacing: 12) {
                Image(systemName: model.type.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(model.type.color)
                
                Text(model.message)
                    .font(AppFont.body)
                    .foregroundStyle(AppColor.textPrimary)
                
                Spacer()
                
                Button(action: { viewModel.dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColor.cardBackground)
                    .shadow(color: AppColor.softShadow, radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 16)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

