//
//  MoonView.swift
//  L4_MoreDimension
//
//  Created by xuchi on 2024/6/30.
//

import SwiftUI
import RealityKit

struct MoonView: View {
    var body: some View {
        VStack {
            Model3D(named: "Moon") { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case let .failure(error):
                    Text(error.localizedDescription)
                        .font(.title)
                case let .success(model):
                    model
                        .resizable()
                        .scaledToFit()
                default:
                    Text("Unknown")
                        .font(.title)
                }
            }
        }
        .padding()
    }
}

#Preview {
    MoonView()
}
