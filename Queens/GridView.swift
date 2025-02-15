//
//  GridView.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import SwiftUI

struct GridView: View {
    
    @Environment(ViewModel.self) var viewModel
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            HStack(spacing: 2.0) {
                
                ForEach(viewModel.grid, id: \.self) { column in
                    VStack(spacing: 2.0) {
                        ForEach(column) { tile in
                            TileView(tile: tile)
                        }
                    }
                }
            }
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    GridView(width: 800,
             height: 800)
}
