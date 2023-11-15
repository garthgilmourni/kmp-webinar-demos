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
