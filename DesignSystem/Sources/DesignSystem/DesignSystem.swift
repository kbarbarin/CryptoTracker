//
//  DesignSystem.swift
//  DesignSystem
//
//  Main entry point for the DesignSystem module
//

import SwiftUI

// MARK: - Foundation
@_exported import struct SwiftUI.Color
@_exported import struct SwiftUI.Font

// Ce fichier sert de point d'entrée principal pour le module DesignSystem
// Tous les composants sont automatiquement exportés via leurs fichiers respectifs

/// Version du Design System
public let designSystemVersion = "1.0.0"

/// Configuration globale du Design System
public struct DesignSystemConfiguration {
    public static let cornerRadius: CGFloat = 20
    public static let cardCornerRadius: CGFloat = 16
    public static let buttonCornerRadius: CGFloat = 12
    public static let inputCornerRadius: CGFloat = 12
    
    public static let defaultSpacing: CGFloat = 16
    public static let defaultPadding: CGFloat = 16
    
    public static let animationDuration: Double = 0.25
    
    public init() {}
}

