//
//  TileData.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import Foundation

struct TileData: Codable {
    var id: Int
    var gridX: Int
    var gridY: Int
    var color: ColorModel
    var queen: Bool
}
