//
//  ViewModel.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import SwiftUI

@Observable class ViewModel {
    
    var paintModel = PaintModel.test
    var paintColor = ColorModel.color04
    
    var groupModels = [GroupModel]()
    
    init() {
        if !load() {
            size(width: 6,
                 height: 6)
        }
    }
    
    var tileID = 0
    
    var width = 0
    var height = 0
    
    var grid = [[TileModel]]()
    
    func click(gridX: Int, gridY: Int) {
        if gridX >= 0 && gridX < width {
            if gridY >= 0 && gridY < height {
                switch paintModel {
                case .colors:
                    grid[gridX][gridY].color = paintColor
                    print("Updated \(gridX), \(gridY) to \(paintColor)")
                case .queens:
                    grid[gridX][gridY].queen_original = !grid[gridX][gridY].queen_original
                    print("Updated \(gridX), \(gridY) to queen = \(grid[gridX][gridY].queen_original)")
                case .test:
                    
                    buildGroups()
                    
                    let eh = existsAnotherFlaggedOrQueen_H(gridX, gridY)
                    let ev = existsAnotherFlaggedOrQueen_V(gridX, gridY)
                    let ed = existsAnotherFlaggedOrQueen_Diagonal_One(gridX, gridY)
                    let eg = existsAnotherFlaggedOrQueen_Group(gridX, gridY)
                    
                    print("@(\(gridX), \(gridY)):")
                    print("existsAnotherFlaggedOrQueen_H: \(eh)")
                    print("existsAnotherFlaggedOrQueen_V: \(ev)")
                    print("existsAnotherFlaggedOrQueen_Diagonal: \(ed)")
                    print("existsAnotherFlaggedOrQueen_Group: \(eg)")
                    
                    if validBoard() {
                        print("Board is VALID!")
                    } else {
                        print("Board is IN-VALID!")
                    }
                    
                }
            }
        }
    }
    
    func size(width: Int, height: Int) {
        
        var _width = width
        if _width < 3 { _width = 3 }
        
        var _height = height
        if _height < 3 { _height = 3 }
        
        var _grid = [[TileModel]](repeating: [TileModel](), count: _width)
        for x in 0..<_width {
            for y in 0..<_height {
                let tileModel = TileModel(id: tileID)
                tileModel.gridX = x
                tileModel.gridY = y
                _grid[x].append(tileModel)
                tileID += 1
            }
        }
        
        for x in 0..<self.width {
            for y in 0..<self.height {
                if x < _width && y < _height {
                    _grid[x][y].color = grid[x][y].color
                    _grid[x][y].queen_original = grid[x][y].queen_original
                }
            }
        }
        
        self.width = _width
        self.height = _height
        self.grid = _grid
        
        print("Sizing to \(width) x \(height)")
    }
    
    @MainActor func width_increase() {
        print("width_increase")
        size(width: width + 1, height: height)
    }
    
    @MainActor func width_decrease() {
        print("width_decrease")
        size(width: width - 1, height: height)
    }
    
    @MainActor func height_increase() {
        print("height_increase")
        size(width: width, height: height + 1)
    }
    
    @MainActor func height_decrease() {
        print("height_decrease")
        size(width: width, height: height - 1)
    }

    var numberOfLoops = 0
    @MainActor func solve() {
        print("solve!")
        
        buildGroups()
        
        for x in 0..<width {
            for y in 0..<height {
                grid[x][y].flag = false
                grid[x][y].queen_discovered = false
            }
        }
        
        if search(0, 0) {
            print("A valid grid was found! Searched \(numberOfLoops) times!")
            
            for x in 0..<width {
                for y in 0..<height {
                    if grid[x][y].flag {
                        grid[x][y].queen_discovered = true
                    }
                }
            }
            
        } else {
            print("A valid grid was not found! Searched \(numberOfLoops) times!")
            
        }
    }
    
    func search(_ gridX: Int, _ gridY: Int) -> Bool {
        
        numberOfLoops += 1
        
        if gridY >= height {
            if validBoard() {
                return true
            } else {
                return false
            }
        }
        
        if let tileModel = getTile(gridX, gridY) {
            
            var nextGridX = gridX + 1
            var nextGridY = gridY
            if nextGridX >= width {
                nextGridX = 0
                nextGridY += 1
            }
            
            // If it's already a queen, or impossible, skip it...
            if tileModel.queen_original || tileModel.impossible {
                if search(nextGridX, nextGridY) {
                    return true
                } else {
                    return false
                }
            }
            
            // Get the group...
            guard let groupModel = tileModel.groupModel else {
                return false
            }
            
            // If there's already a queen in this group, skip it.
            if groupModel.numberOfQueenOrFlagTiles >= 1 {
                if search(nextGridX, nextGridY) {
                    return true
                } else {
                    return false
                }
            }
            
            // Is it possible to place a queen here?
            let exists1 = existsAnotherFlaggedOrQueen_H(gridX, gridY)
            let exists2 = existsAnotherFlaggedOrQueen_V(gridX, gridY)
            let exists3 = existsAnotherFlaggedOrQueen_Diagonal_One(gridX, gridY)
            
            // If it is, try both, otherwise skip...
            if exists1 || exists2 || exists3 {
                if search(nextGridX, nextGridY) {
                    return true
                } else {
                    return false
                }
            } else {
                
                // 1.) Try a search with this tile flagged:
                tileModel.flag = true
                if search(nextGridX, nextGridY) {
                    return true
                }
                
                // 1.) Try a search with this tile not flagged:
                tileModel.flag = false
                if search(nextGridX, nextGridY) {
                    return true
                }
                
            }
            
        }

        return false
    }
    
    func buildGroups() {
        
        groupModels.removeAll(keepingCapacity: true)
        
        for colorModel in ColorModel.allCases {
            
            var tileModels = [TileModel]()
            for x in 0..<width {
                for y in 0..<height {
                    if grid[x][y].color == colorModel {
                        tileModels.append(grid[x][y])
                    }
                }
            }
            if tileModels.count > 0 {
                let group = GroupModel(colorModel: colorModel, tileModels: tileModels)
                groupModels.append(group)
            }
        }
        
        for groupModel in groupModels {
            for tileModel in groupModel.tileModels {
                tileModel.groupModel = groupModel
            }
        }
    }
    
    func validBoard() -> Bool {
        for groupModel in groupModels {
            let numberOfQueens = groupModel.numberOfQueenOrFlagTiles
            
            if numberOfQueens <= 0 {
                //print("board invalid because group \(groupModel.colorModel) has no queen")
                return false
            }
            
            if numberOfQueens > 1 {
                //print("board invalid because group \(groupModel.colorModel) has \(numberOfQueens) queens")
                return false
            }
        }
        
        for x in 0..<width {
            for y in 0..<height {
                let tileModel = grid[x][y]
                if tileModel.queen_original || tileModel.flag {
                    
                    if existsAnotherFlaggedOrQueen_H(x, y) {
                        //print("board is invalid because \(x), \(y) conflicts horizontally")
                        return false
                    }
                    
                    if existsAnotherFlaggedOrQueen_V(x, y) {
                        //print("board is invalid because \(x), \(y) conflicts vertically")
                        return false
                    }
                    
                    if existsAnotherFlaggedOrQueen_Diagonal_One(x, y) {
                        //print("board is invalid because \(x), \(y) touches neighbor diagonally")
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func existsAnotherFlaggedOrQueen_H(_ gridX: Int, _ gridY: Int) -> Bool {
        
        var x = 0
        
        // To the left:
        x = gridX - 1
        while x >= 0 {
            if let tile = getTile(x, gridY) {
                if tile.queen_original || tile.flag {
                    return true
                }
            }
            x -= 1
        }
        
        // To the right:
        x = gridX + 1
        while x < width {
            if let tile = getTile(x, gridY) {
                if tile.queen_original || tile.flag {
                    return true
                }
            }
            x += 1
        }
        
        return false
    }
    
    
    func existsAnotherFlaggedOrQueen_V(_ gridX: Int, _ gridY: Int) -> Bool {
        var y = 0
        
        // To the up:
        y = gridY - 1
        while y >= 0 {
            if let tile = getTile(gridX, y) {
                if tile.queen_original || tile.flag {
                    return true
                }
            }
            y -= 1
        }
        
        // To the down:
        y = gridY + 1
        while y < height {
            if let tile = getTile(gridX, y) {
                if tile.queen_original || tile.flag {
                    return true
                }
            }
            y += 1
        }
        
        return false
    }
    
    func existsAnotherFlaggedOrQueen_Diagonal_One(_ gridX: Int, _ gridY: Int) -> Bool {
        
        var y = 0
        var x = 0
        
        // To the up-left:
        y = gridY - 1
        x = gridX - 1
        if let tile = getTile(x, y) {
            if tile.queen_original || tile.flag {
                return true
            }
        }
        
        // To the up-right:
        y = gridY - 1
        x = gridX + 1
        if let tile = getTile(x, y) {
            if tile.queen_original || tile.flag {
                return true
            }
        }
        
        // To the down-left:
        y = gridY + 1
        x = gridX - 1
        if let tile = getTile(x, y) {
            if tile.queen_original || tile.flag {
                return true
            }
        }
        
        // To the down-right:
        y = gridY + 1
        x = gridX + 1
        if let tile = getTile(x, y) {
            if tile.queen_original || tile.flag {
                return true
            }
        }
        
        return false
    }
    
    func existsAnotherFlaggedOrQueen_Group(_ gridX: Int, _ gridY: Int) -> Bool {
        if let tile = getTile(gridX, gridY) {
            if let groupModel = tile.groupModel {
                for tileModel in groupModel.tileModels {
                    if tileModel.gridX != gridX || tileModel.gridY != gridY {
                        if tileModel.queen_original || tileModel.flag {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func getTile(_ gridX: Int, _ gridY: Int) -> TileModel? {
        if gridX >= 0 && gridX < width && gridY >= 0 && gridY < height {
            return grid[gridX][gridY]
        }
        return nil
    }
}

extension ViewModel {
    
    func save() {
        let gridData = GridData(width: width, height: height, tiles: grid.flatMap { $0.map { tile in
            TileData(id: tile.id, gridX: tile.gridX, gridY: tile.gridY, color: tile.color, queen: tile.queen_original)
        }})
        
        let fileURL = getDocumentsDirectory().appendingPathComponent("gridData.json")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(gridData)
            try data.write(to: fileURL)
            print("Saved grid data to \(fileURL)")
        } catch {
            print("Failed to save grid data: \(error)")
        }
    }
    
    func load() -> Bool {
        let fileURL = getDocumentsDirectory().appendingPathComponent("gridData.json")
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let gridData = try decoder.decode(GridData.self, from: data)
            
            if gridData.width < 3 { return false }
            if gridData.height < 3 { return false }
            
            // Initialize the grid with new dimensions
            self.size(width: gridData.width, height: gridData.height)
            
            // Populate the grid with loaded tile data
            for tile in gridData.tiles {
                if tile.gridX < width && tile.gridY < height {
                    grid[tile.gridX][tile.gridY].color = tile.color
                    grid[tile.gridX][tile.gridY].queen_original = tile.queen
                }
            }
            
            print("Loaded grid data from \(fileURL)")
            return true
        } catch {
            print("Failed to load grid data: \(error)")
            return false
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
