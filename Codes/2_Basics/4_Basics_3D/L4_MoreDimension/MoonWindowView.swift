//
//  MoonWindowView.swift
//  L4_MoreDimension
//
//  Created by xuchi on 2024/6/30.
//

import SwiftUI
import RealityKit

struct MoonWindowView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: geometry.size.height / 4)

                Model3D(named: "Moon") { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .failure(error):
                        Text(error.localizedDescription)
                            .font(.title)
                    case let .success(model):
                        model
                    default:
                        Text("Unknown")
                            .font(.title)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height / 2)

                Text("The Moon")
                    .font(.largeTitle)
                    .frame(height: geometry.size.height / 8)
                
                Spacer()
                    .frame(height: geometry.size.height / 8)

            }
            .padding()
        }
    }
}

#Preview {
    MoonView()
}
