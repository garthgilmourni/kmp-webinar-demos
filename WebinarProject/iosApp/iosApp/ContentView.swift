import SwiftUI
import Shared


struct CardView: View {
    let countryImage: String
    let countryDescription: String

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
            }
        }
                .frame(width: 300, height: 200)
    }
}


struct ContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(1...20, id: \.self) {
                    CardView(countryImage: "Ireland\($0)", countryDescription: "The emerald isle")
                }
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
