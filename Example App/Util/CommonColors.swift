//
//  CommonColors.swift
//  Example App
//
//  Created by Emmanuel Ramírez on 13/01/25.
//

import SwiftUI

enum CommonColors {
    
    case surface
    case background
    
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .surface:
            return scheme == .light ? Color(uiColor: UIColor.systemBackground) : Color(uiColor: UIColor.secondarySystemBackground)
        case .background:
            return scheme == .light ? Color(uiColor: UIColor.secondarySystemBackground) : Color(uiColor: UIColor.systemBackground)
        }
    }
}
