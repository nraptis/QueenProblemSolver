//
//  TileView.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import SwiftUI

struct NoBackgroundButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct TileView: View {
    
    @Environment(ViewModel.self) var viewModel
    
    let tile: TileModel
    var body: some View {
        ZStack {
            Button {
                
                print("Clicked Tile: \(tile.gridX), \(tile.gridY)")
                
                let tile = viewModel.grid[tile.gridX][tile.gridY]
                
                print("Tile: \(tile.id)")
                print("Self: \(self.tile.id)")
                print("==== Same? ====")
                
                viewModel.click(gridX: tile.gridX, gridY: tile.gridY)
                
            } label: {
                ZStack {
                    if tile.queen_original {
                        Text("👑")
                            .font(.system(size: 32.0))
                        
                    } else if tile.queen_discovered {
                        Text("👸")
                            .font(.system(size: 32.0))
                        
                    }
                }
                .frame(width: 54.0, height: 54.0)
                .background(RoundedRectangle(cornerRadius: 10.0).foregroundStyle(tile.color.color))
            }

        }
        .frame(width: 56.0, height: 56.0)
        .buttonStyle(NoBackgroundButtonStyle()) // Apply the custom button style
        
    }
}

#Preview {
    TileView(tile: TileModel(id: 0))
}
