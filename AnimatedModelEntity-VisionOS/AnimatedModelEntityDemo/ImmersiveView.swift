//
//  ImmersiveView.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 10/6/23.
//

import Foundation
import SwiftUI
import _RealityKit_SwiftUI

struct ImmersiveView: View {
    var viewModel: ViewModel
    
    var body: some View {
        VStack {
            RealityView { content in
                content.add(rootEntity)
            }.task {
                viewModel.spawnFloor()
                await viewModel.loadDiver()
            }
        }
    }
}
