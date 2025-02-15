//
//  GridData.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import Foundation

struct GridData: Codable {
    var width: Int
    var height: Int
    var tiles: [TileData]
}
