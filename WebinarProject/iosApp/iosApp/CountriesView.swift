import SwiftUI
import Shared
import KMPNativeCoroutinesCore
import KMPNativeCoroutinesAsync

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