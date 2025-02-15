//
//  ColorModel.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import SwiftUI

enum ColorModel: UInt8 {
    case color00
    case color01
    case color02
    case color03
    case color04
    case color05
    case color06
    case color07
    case color08
    case color09
    case color10
    case color11
}

extension ColorModel: Codable {
    
}

extension ColorModel {
    
    var color: Color {
        switch self {
        case .color00:
            return Color.color00
        case .color01:
            return Color.color01
        case .color02:
            return Color.color02
        case .color03:
            return Color.color03
        case .color04:
            return Color.color04
        case .color05:
            return Color.color05
        case .color06:
            return Color.color06
        case .color07:
            return Color.color07
        case .color08:
            return Color.color08
        case .color09:
            return Color.color09
        case .color10:
            return Color.color10
        case .color11:
            return Color.color11
        }
    }
    
}
