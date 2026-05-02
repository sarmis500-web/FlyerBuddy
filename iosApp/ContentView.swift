import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "airplane")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Flyer Buddy!")
                .font(.largeTitle)
                .bold()
            Text("Your ultimate travel companion.")
                .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
