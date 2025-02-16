//
//  TileModel.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import Foundation

@Observable class TileModel {
    
    var gridX = 0
    var gridY = 0
    
    var id: Int
    var color = ColorModel.color00
    
    var queen_original = false
    var queen_discovered = false
    
    var impossible = false
    
    var groupModel: GroupModel!
    
    @ObservationIgnored var flag = false
    
    
    init(id: Int) {
        self.id = id
    }
    
}

extension TileModel: Identifiable {
    
}

extension TileModel: Hashable {
    static func == (lhs: TileModel, rhs: TileModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

