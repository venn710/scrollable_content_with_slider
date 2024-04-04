//
//  ScrollableContentWithSlider.swift
//  scrollable-content-with-slider
//
//  Created by Venkatesham Boddula on 02/04/24.
//

import SwiftUI

struct ScrollableContentWithSlider<T: View>: View {
    
    /// A Boolean which can be used to show or hide the slider
    var showSlider: Bool = true
    
    /// A Boolean which can be used to animate the content after every 1.5 sec (which can be changed accordingly.)
    var shouldAnimate: Bool = false
    
    /// Color which is given to background slider
    var backgroundSliderColor: Color = .gray
    
    /// Color which is given to foreground slider.
    var foregroundSliderColor: Color = .blue
    
    /// Width of the Background Slider
    var backgroundSliderWidth: Double = 98
    
    /// Height of the Background Slider
    var backgroundSliderHeight: Double = 6
    
    /// Spacing in between views. which are given as list in content
    var spacingInBetween: Double = 8
    
    /// List of Views which can be scrollable.
    let content: [T]
    
    
    /// This denotes the horizontal scroll position of the Scrollview in the coordinatespace named 'scrollview'
    @State private var horizontalScrollPosition: Double = 0
    
    /// This denotes the width of the Single View which is given in the content.
    @State private var singleCardWidth: Double = 0
    
    /// This denotes the total AvailableWidth of the Device.
    @State private var availableWidth: Double = 0
    
    /// Timer Publisher which is used to scroll automatically after every 1.5 sec
    @State private var timerPublisher = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    /// This denotes the scrolled Index which is being used as an identifier for scrolling to a specific card during Animation.
    @State private var scrolledIndex: Int = 0
    
    /// This foregroundSliderWidth is the Width of the Inner Slider of colour 'sliderForegroundColor'.
    /// Here subtracting 2 which refers to the Padding which we gave for the foregroundSlider.
    private var foregroundSliderWidth: Double {
        let count: Double = Double(content.count)
        return (backgroundSliderWidth - 2) / count
    }
    
    /// This Refers to the total Width taken up by the ScrollView after building all the views from content.
    private var totalScrollableAreaWidth: Double {
        let count: Double = Double(content.count)
        return singleCardWidth * count + (count - 1) * spacingInBetween
    }
    
    /*
     This is used as the Padding for the inner slider.
     
     1. At first I'm checking for the singleCardWidth which will be assigned after the content is built
     2. Then I'm getting the percentage of the scrolled portion
     3. Considering the scenario where scrolling occurs towards the right side of the coordinate space hence horizontalScrollPosition should be < 0 
     else leading padding will be 0
     4. Only considering the scrolling inside available width hence scrolledPortion will be in my (0 to 1) else leading padding will be
     remaining area in my slider which is ((backgroundSliderWidth - 2) - foregroundSliderWidth)
     5. Used abs because horizontalScrollPosition will be -ve when we move right inside coordinate space.
     
     */
    private var scrollerLeadingPadding: Double{
        if singleCardWidth == 0 {
            return 0
        }
        let scrolledPortion: Double = horizontalScrollPosition / (totalScrollableAreaWidth - availableWidth)
        
        if (horizontalScrollPosition < 0){
            if(abs(scrolledPortion) <= 1){
                return abs(scrolledPortion) * ((backgroundSliderWidth - 2) - foregroundSliderWidth)
            } else {
                return (backgroundSliderWidth - 2) - foregroundSliderWidth
            }
        } else {
            return 0
        }
    }
    
    var body: some View {
        
        ScrollViewReader { proxy in
            VStack(alignment: .center, spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacingInBetween) {
                        ForEach(content.indices, id: \.self) { index in
                            content[index]
                                .id(index)
                                .background {
                                    GeometryReader(content: { geometry in
                                        Color.clear
                                            .onAppear {
                                                singleCardWidth = geometry.size.width
                                            }
                                    })
                                }
                        }
                    }
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        self.horizontalScrollPosition = Double(value.x)
                    }
                }
                .coordinateSpace(name: "scroll")
                if totalScrollableAreaWidth - availableWidth > 0 && showSlider {

                    /// Background slider will stay intact with the given width and height.
                    Rectangle()
                        .fill(backgroundSliderColor)
                        .cornerRadius(100)
                        .frame(width: backgroundSliderWidth, height: backgroundSliderHeight)
                        .overlay(alignment: .leading) {
                            
                            /// Foreground slider will slide over the background slider with the changing scrollerLeadingPadding.
                            Rectangle()
                                .fill(foregroundSliderColor)
                                .cornerRadius(100)
                                .frame(width: foregroundSliderWidth)
                                .padding(1)
                                .padding(.leading, scrollerLeadingPadding)
                        }
                }
            }
            .background(content: {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            availableWidth = geo.size.width
                        }
                }
            })
            .onReceive(timerPublisher, perform: { _ in
                if shouldAnimate && totalScrollableAreaWidth > availableWidth {
                    if abs(horizontalScrollPosition) == totalScrollableAreaWidth - availableWidth {
                        scrolledIndex = 0
                    } else {
                        scrolledIndex += 1
                    }
                    withAnimation {
                        proxy.scrollTo(scrolledIndex, anchor: .leading)
                    }
                }
            })
        }
        .task {
            
            /// Timer will be connected automatically when the view appears.
            timerPublisher = timerPublisher.upstream.autoconnect()
            
            /// If we don't want it to animate then the timer will be cancelled when view is rendered.
            if !shouldAnimate {
                timerPublisher.upstream.connect().cancel()
            }
        }
        .onDisappear {
            
            /// Cancelling the timer.
            timerPublisher.upstream.connect().cancel()
        }
    }
}
