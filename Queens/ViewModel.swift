//
//  ViewModel.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import SwiftUI

@Observable class ViewModel {
    
    var paintMode = PaintMode.colors
    
    var paintColor = ColorModel.color04
    
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
                switch paintMode {
                case .colors:
                    grid[gridX][gridY].color = paintColor
                    print("Updated \(gridX), \(gridY) to \(paintColor)")
                case .queens:
                    grid[gridX][gridY].queen = !grid[gridX][gridY].queen
                    print("Updated \(gridX), \(gridY) to queen = \(grid[gridX][gridY].queen)")
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
                
                var tileModel = TileModel(id: tileID)
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
                    _grid[x][y].queen = grid[x][y].queen
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

    @MainActor func solve() {
        print("solve!")
    }
    
    
}

extension ViewModel {
    
    func save() {
        let gridData = GridData(width: width, height: height, tiles: grid.flatMap { $0.map { tile in
            TileData(id: tile.id, gridX: tile.gridX, gridY: tile.gridY, color: tile.color, queen: tile.queen)
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
                    grid[tile.gridX][tile.gridY].queen = tile.queen
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
