# ScrollableContentWithSlider

ScrollableContentWithSlider is a helper view which can be used as a Slider with Data.

## Problem Statement

Develop a custom SwiftUI View component that integrates a slider within a scrollable view. The slider should dynamically adjust its position in response to the user's scrolling gestures within the scroll view, simulating a visual effect similar to moving the slider back and forth along the scrolling direction.

### Available Native Solutions.
In swiftUI there is no Direct way to configure the scrollIndicator which we get in ScrollView so by using GeometryReader and PreferenceKeys we can mimic the functionality of ScrollIndicator.

### Solution


To replicate the behaviour of ScrollIndicators in a SwiftUI ScrollView, I've implemented the following steps:

1. ScrollableContentWithSlider component requires a "content" parameter, which expects a list of Views to populate the ScrollView.
2. I've used two Sliders where one slides over the another, the Outer Slider width and height are fixed and can be configurable where Inner Slider will slide over the outer slider.
3. Assigned the named coordinate space(scroll) to the ScrollView.
4. Reading the changes when the user scrolls in the coordinate space(scroll) using the Preference Keys then updating the inner slider position.
5. I've implemented sliding behaviour using two sliders: an outer slider and an inner slider. The inner slider is positioned above the outer slider. As the leading padding of the inner slider adjusts, it creates the sliding effect.
6. By using the below computed property the inner slider leading padding gets calculated.
``` swift
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
```

1. At first I'm calculating the singleCardWidth which refers to the width of the single view in list of views that are passed in content.

2. Everytime user scrolls inside the coordinate space we can capture the position to which he scrolled to by using onPreferenceChange modifier which is used to update the horizontalScrollPosition

2. Then I'm getting the percentage of the scrolled portion

3. Considering the scenario where scrolling occurs towards the right side of the coordinate space hence horizontalScrollPosition should be < 0 else leading padding will be 0

4. Only considering the scrolling inside available width hence scrolledPortion will be in my (0 to 1) else leading padding will be remaining area in my scroller which is ((backgroundSliderWidth - 2) - foregroundSliderWidth)

5. Used abs because horizontalScrollPosition will be -ve when we move right inside coordinate space.

 
## Working

With Animation

https://github.com/venn710/scrollable_content_with_slider/assets/63038237/a616b962-4b05-4862-ae05-a31e6364f458

Without Animation


https://github.com/venn710/scrollable_content_with_slider/assets/63038237/0db7d46b-546e-4e28-9706-a0384f01bac7




Here if we enable shouldAnimate bool then it will animate as above but if we don't want to animate it then we don't need to do anything since shouldAnimate property is being given as false as a default parameter.

## Usage

I've developed a versatile view with configurable properties, allowing for flexible utilisation across various contexts.

``` swift

struct ExampleView: View {
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
```
ScrollableContentWithSlider takes a property called content in which we have to give the list of views which we want to render.

Here I'm Building list of Rectangle Views of different colors and passing it into ScrollableContentWithSlider which will take these views and render along with slider.
