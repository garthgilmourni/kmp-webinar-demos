import SwiftUI
import Shared


struct WeatherDetails {
    let part1: String
    let part2: String
}

struct CardView: View {
    let countryImage: String
    let countryDescription: String
    let action: (WeatherDetails) -> ()

    init(countryImage: String, countryDescription: String, action: @escaping (WeatherDetails) -> ()) {
        self.countryImage = countryImage
        self.countryDescription = countryDescription
        self.action = action
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.white)
                    .shadow(radius: 10)

            VStack {
                Image(systemName: "swift")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                Text(countryImage)
                Text(countryDescription)
                Button("Push Me") {
                    action(WeatherDetails(part1: countryImage, part2: "Sunny"))
                }
            }
        }.frame(width: 300, height: 200)
    }
}

struct ContentView: View {
    @State private var showDetailsView = false
    @State private var weatherDetails: WeatherDetails?

    var body: some View {
        if (showDetailsView) {
            WeatherView(details: weatherDetails.unsafelyUnwrapped) {
                withAnimation {
                    showDetailsView.toggle()
                }
            }.transition(.scale)
        } else {
            CountriesView { details in
                withAnimation {
                    showDetailsView.toggle()
                    weatherDetails = details
                }
            }
        }
    }
}

struct CountriesView: View {
    let action: (WeatherDetails) -> ()

    init(action: @escaping (WeatherDetails) -> ()) {
        self.action = action
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(1...20, id: \.self) {
                    CardView(countryImage: "Ireland\($0)", countryDescription: "The emerald isle", action: action)
                }
            }
        }.padding()
    }
}

struct WeatherView: View {

    let details: WeatherDetails
    let action: () -> ()

    init(details: WeatherDetails, action: @escaping () -> ()) {
        self.details = details
        self.action = action
    }

    var body: some View {
        Text("It is \(details.part2) in \(details.part1)")
        Button("Push Me") {
            action()
        }
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
