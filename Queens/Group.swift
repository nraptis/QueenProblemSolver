//
//  Group.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import Foundation

class GroupModel: CustomStringConvertible {
    
    let colorModel: ColorModel
    let tileModels: [TileModel]
    let tileModelSet: Set<TileModel>
    
    var flag = false
    
    init(colorModel: ColorModel, tileModels: [TileModel]) {
        self.colorModel = colorModel
        self.tileModels = tileModels
        tileModelSet = Set(tileModels)
    }
    
    var description: String {
        var result = "Group for \(colorModel)\n"
        for tileModel in tileModels {
            result += "Tile [\(tileModel.gridX), \(tileModel.gridY)]\n"
        }
        result += "<== End of Group ==>"
        return result
    }
    
    var numberOfQueenOrFlagTiles: Int {
        var result = 0
        for tileModel in tileModels {
            if tileModel.queen_original || tileModel.flag {
                result += 1
            }
        }
        return result
    }
}
