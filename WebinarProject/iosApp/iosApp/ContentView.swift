import SwiftUI
import Shared
import KMPNativeCoroutinesCore
import KMPNativeCoroutinesAsync
import Kingfisher

struct Capital {
    let name: String
    let lat: Double
    let long: Double
}

struct CardView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    let action: (String, Weather) -> ()
    
    @State var country: Country

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.white)
                    .shadow(radius: 10)
            HStack {
                
                KFImage
                    .url(URL(string: country.flags.png))
                    .setProcessor(DownsamplingImageProcessor(size: CGSizeMake(75.0, 75.0)))
                    .frame(width: 75, alignment: .leading)
                    .border(Color.gray)
                    .padding(15)
                    .frame(height: 150, alignment: .top)
                Spacer()
                VStack {
                    
                    Text(country.name.common).font(.body).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 10)).frame(maxWidth: .infinity, alignment: .leading)
                    Text(country.name.official).font(.caption).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)).frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    VStack {
                        Spacer()
                        ForEach(country.capital, id: \.self) { capital in
                            Button("\(capital) weather") {
                                viewModel.loadWeather(capitalName: capital,
                                                      lat: Double(country.capitalInfo!.latlng[0]),
                                                      long: Double(country.capitalInfo!.latlng[1]),
                                                      action: self.action)
                            }.padding(20)
                            
                        }
                    }
                }.frame(width: 200, alignment: .leading)
            }
        }
        .frame(width: 300, height: 150, alignment: .leading)
    }
    
    @MainActor
    class ViewModel: ObservableObject {

        let sdk: WeatherApi = WeatherApi()

        func loadWeather(capitalName: String, lat: Double, long: Double, action: @escaping (String, Weather) -> ()) {
            Task {
                let weather = try await asyncFunction(for: sdk.getWeather(lat: lat, long: long))
                action(capitalName, weather)
            }
        }
    }
}

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()

    var body: some View {
        if (viewModel.showDetailsView) {
            WeatherView(capitalName: viewModel.capitalName!, details: viewModel.weatherDetails!) {
                withAnimation {
                    viewModel.showDetailsView.toggle()
                }
            }.transition(.scale)
        } else {
            CountriesView { capitalName, details in
                withAnimation {
                    viewModel.showDetailsView.toggle()
                    viewModel.capitalName = capitalName
                    viewModel.weatherDetails = details
                }
            }
        }
    }
    
    class ViewModel: ObservableObject {
        @Published var showDetailsView = false
        @Published var capitalName: String?
        @Published var weatherDetails: Weather?
    }
}

struct CountriesView: View {

    enum LoadableCountry {
        case loading
        case result([Country])
        case error(String)
    }

    @ObservedObject private(set) var viewModel: ViewModel = ViewModel()

    let action: (String, Weather) -> ()

    init(action: @escaping (String, Weather) -> ()) {
        self.action = action
    }

    var body: some View {
        switch viewModel.loadableCountries {
         case .loading:
             return AnyView(Text("Loading...").multilineTextAlignment(.center))
         case .result(let countries):
             return AnyView(List(countries) { country in
                 CardView(action: self.action, country: country)
             })
         case .error(let description):
             return AnyView(Text(description).multilineTextAlignment(.center))
        }
    }

    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var loadableCountries = LoadableCountry.loading

        let sdk: CountryApi = CountryApi()

        init() {
            self.loadCountries(forceReload: false)
        }

        func loadCountries(forceReload: Bool) {
            Task {
                do {
                    self.loadableCountries = .loading
                    let countries = try await asyncFunction(for: sdk.getAllCountries())
                    self.loadableCountries = .result(countries)
                } catch {
                    self.loadableCountries = .error(error.localizedDescription)
                }
            }
        }
    }
}

struct WeatherView: View {
    
    let capitalName: String

    let details: Weather
    
    let action: () -> ()

    init(capitalName: String, details: Weather, action: @escaping () -> ()) {
        self.capitalName = capitalName
        self.details = details
        self.action = action
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            VStack {
                Button("Back") {
                    action()
                }.frame(width: 300, alignment: .leading).padding(20)
                Text(capitalName).font(.title)
                KFImage(URL(string: "https://openweathermap.org/img/wn/\(details.weather[0].icon)@2x.png")!)
                Text("Feels like: \(details.main.feels_like)'C / \(CelsiusToFahrenheitKt.celsiusToFahrenheit(celcius: details.main.feels_like))'F" ).frame(width: 300, alignment: .leading).padding(5)
                Text("Temp: \(details.main.temp)'C / \(CelsiusToFahrenheitKt.celsiusToFahrenheit(celcius: details.main.temp))'F").frame(width: 300, alignment: .leading).padding(EdgeInsets(top: 5, leading: 5, bottom: 15, trailing: 5))
                
            }
        }.frame(width: 300, height: 300)
    
    }
}

extension Country: Identifiable { }
