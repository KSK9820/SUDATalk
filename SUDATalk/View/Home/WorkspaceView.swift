//
//  WorkspaceView.swift
//  SUDATalk
//
//  Created by 김수경 on 12/3/24.
//

import SwiftUI

struct WorkspaceView: View {
    @Binding var offsetX: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.gray.opacity(0.8)
            
            HStack {
                Color.white
                    .frame(width: ContentSize.workspaceScreen.size.width)
                    .offset(x: offsetX)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dragAmount = value.translation.width
                                if dragAmount >= 0 {
                                    offsetX = min(0, -ContentSize.workspaceScreen.size.width)
                                }
                            }
                            .onEnded { value in
                                let dragAmount = value.translation.width
                                withAnimation {
                                    if dragAmount > ContentSize.screenWidth / 4 {
                                        offsetX = 0
                                    } else {
                                        offsetX = -ContentSize.screenWidth
                                    }
                                }
                            }
                    )
                Spacer()
            }
            .frame(width: ContentSize.workspaceScreen.size.width)
            .background(Color.white)
            .cornerRadius(60)
        }
        .ignoresSafeArea()
    }
}
