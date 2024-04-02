//
//  ContentView.swift
//  scrollable-content-with-slider
//
//  Created by Venkatesham Boddula on 02/04/24.
//

import SwiftUI

/// An Example of how we can use Slider.
struct ContentView: View {
    private var listOfColors: [Color] = [
        .red,
        .green,
        .blue,
        .green,
        .yellow,
        .orange,
        .purple
    ]
    
    var body: some View {
        
        ScrollView {
            ScrollableContentWithSlider(
                shouldAnimate: true,
                content: listOfColors
                    .map { _color in
                        Rectangle()
                            .fill(_color)
                            .frame(width: 100, height: 200)
                    }
            )
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
