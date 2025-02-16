//
//  ContentView.swift
//  Queens
//
//  Created by Nicholas Raptis on 2/15/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        return VStack(spacing: 0.0) {
            HStack {
                Spacer()
                Button {
                    viewModel.width_decrease()
                } label: {
                    ZStack {
                        Text("Width -= 1")
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 144.0, height: 44.0)
                    .background(RoundedRectangle(cornerRadius: 16.0).foregroundStyle(Color.blue))
                }
                Button {
                    viewModel.width_increase()
                } label: {
                    ZStack {
                        Text("Width += 1")
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 144.0, height: 44.0)
                    .background(RoundedRectangle(cornerRadius: 16.0).foregroundStyle(Color.blue))
                }
                
                Spacer()
                
                Button {
                    viewModel.height_decrease()
                } label: {
                    ZStack {
                        Text("Height -= 1")
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 144.0, height: 44.0)
                    .background(RoundedRectangle(cornerRadius: 16.0).foregroundStyle(Color.blue))
                }
                Button {
                    viewModel.height_increase()
                } label: {
                    ZStack {
                        Text("Height += 1")
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 144.0, height: 44.0)
                    .background(RoundedRectangle(cornerRadius: 16.0).foregroundStyle(Color.blue))
                }
                Spacer()
            }
            .frame(height: 44.0)
            
            VStack {
                HStack {
                    Picker("", selection: $viewModel.paintMode) {
                        Text("Colors").tag(PaintMode.colors)
                        Text("Queens").tag(PaintMode.queens)
                        Text("Test").tag(PaintMode.test)
                        
                        
                        
                                }
                                .pickerStyle(.segmented)
                }
            }
            .frame(height: 44.0)
            
            VStack {
                HStack {
                    Picker("", selection: $viewModel.paintColor) {
                        
                        Text("CLR_00").tag(ColorModel.color00)
                        Text("CLR_01").tag(ColorModel.color01)
                        Text("CLR_02").tag(ColorModel.color02)
                        Text("CLR_03").tag(ColorModel.color03)
                        Text("CLR_04").tag(ColorModel.color04)
                        Text("CLR_05").tag(ColorModel.color05)
                        Text("CLR_06").tag(ColorModel.color06)
                        Text("CLR_07").tag(ColorModel.color07)
                        Text("CLR_08").tag(ColorModel.color08)
                        Text("CLR_09").tag(ColorModel.color09)
                        Text("CLR_10").tag(ColorModel.color10)
                        Text("CLR_11").tag(ColorModel.color11)
                    }
                    .pickerStyle(.segmented)
                        
                }
            }
            .frame(height: 44.0)
            
            HStack(spacing: 0.0) {
                
                VStack {
                    
                }
                .frame(width: 256.0)
                
                GeometryReader { geometry in
                    GridView(width: geometry.size.width,
                             height: geometry.size.height)
                }
                .background(Color.pink)
                
                VStack {
                    
                    Button {
                        
                        viewModel.solve()
                    } label: {
                        ZStack {
                            Text("Solve")
                                .foregroundStyle(Color.white)
                        }
                        .frame(width: 144.0, height: 44.0)
                        .background(RoundedRectangle(cornerRadius: 16.0).foregroundStyle(Color.blue))
                    }
                    
                    Button {
                        
                        viewModel.save()
                    } label: {
                        ZStack {
                            Text("Save")
                                .foregroundStyle(Color.white)
                        }
                        .frame(width: 144.0, height: 44.0)
                        .background(RoundedRectangle(cornerRadius: 16.0).foregroundStyle(Color.blue))
                    }
                    
                    Button {
                        
                        _ = viewModel.load()
                    } label: {
                        ZStack {
                            Text("Load")
                                .foregroundStyle(Color.white)
                        }
                        .frame(width: 144.0, height: 44.0)
                        .background(RoundedRectangle(cornerRadius: 16.0).foregroundStyle(Color.blue))
                    }
                    
                }
                .frame(width: 256.0)
                
            }
            
            
            
        }
        .frame(width: 1200, height: 800)
    }
}

#Preview {
    ContentView()
}
