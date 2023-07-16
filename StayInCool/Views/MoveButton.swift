//
//  MoveButton.swift
//  StayInCool
//
//  Created by kbj on 2023/7/15.
//

import SwiftUI

struct MoveButton: View {
    private let circleWidth = CGFloat(60)
    @State private var dragAmount: CGPoint?
    var action: (() -> Void)?
    var isDraggable: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                self.action?()
            }, label: {
                ZStack{
                    Circle()
                        .foregroundColor(.blue)
                        .shadow(radius: 5)
                    Image(systemName: "cloud.sun")
                        .foregroundColor(.white)
                }
            })
            .frame(width: circleWidth, height: circleWidth)
            .animation(.default, value: true)
            .position(self.dragAmount ?? CGPoint(x: geometry.size.width - circleWidth - 15, y: geometry.size.height - circleWidth))
            .highPriorityGesture(isDraggable ? DragGesture().onChanged { value in
                var location = value.location
                let contant = circleWidth / 2 + CGFloat(20)
                if location.x < contant {
                    location.x = contant
                } else if location.x > geometry.size.width - contant {
                    location.x = geometry.size.width - contant
                }
                if location.y < contant {
                    location.y = contant
                } else if location.y > geometry.size.height - contant {
                    location.y = geometry.size.height - contant
                }
                self.dragAmount = location
            } : nil)
        }
    }
}

struct MoveButton_Previews: PreviewProvider {
    static var previews: some View {
        MoveButton()
    }
}
