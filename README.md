# ScrollableContentWithSlider

ScrollableContentWithSlider is a helper view which can be used as a Slider with Data.
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
