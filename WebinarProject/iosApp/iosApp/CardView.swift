import SwiftUI
import Shared
import Kingfisher
import KMPNativeCoroutinesCore
import KMPNativeCoroutinesAsync

struct CardView: View {

    @StateObject var viewModel: ViewModel = ViewModel()

    let action: (String, Weather) -> ()

    @State var country: Country

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.white)
                    .shadow(radius: 10)
            VStack {
                HStack {
                    KFImage
                            .url(URL(string: country.flags.png))
                            .setProcessor(DownsamplingImageProcessor(size: CGSizeMake(75.0, 75.0)))
                            .frame(width: 75, alignment: .leading)
                            .border(Color.gray)
                            .padding(15)
                            .frame(height: 150)
                    VStack(alignment: .leading) {
                        Text(country.name.common).font(.body).fontWeight(.bold)
                        Text(country.name.official).font(.caption)
                    }.frame(alignment: .bottom)
                }.frame(maxWidth: .infinity, alignment: .leading)

                ForEach(country.capital, id: \.self) { capital in
                    Button("\(capital) weather") {
                        viewModel.loadWeather(capitalName: capital,
                            lat: Double(country.capitalInfo!.latlng[0]),
                            long: Double(country.capitalInfo!.latlng[1]),
                            action: self.action)
                    }.frame(maxWidth: .infinity, alignment: .center).padding(20)
                }
            }
        }
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
