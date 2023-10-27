import SwiftUI

struct ContentView: View {
    @State private var cards: [String]
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "cards"),
           let loadedCards = try? JSONDecoder().decode([String].self, from: data) {
            _cards = State(initialValue: loadedCards)
        } else {
            _cards = State(initialValue: ["Journal"])
        }
    }


    // ... rest of your code ...


    var body: some View {
        NavigationView {
            VStack {
                // Added title
                Text("DJournal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding(.leading, -188)
                
                List {
                    ForEach(cards.indices, id: \.self) { index in
                        NavigationLink(destination: DetailView(content: $cards[index])) {
                            CardView(content: cards[index])
                        }
                    }
                    .onDelete(perform: deleteCard)
                }
                
                .overlay(
                        Button(action: {
                            cards.append("New Journal")
                            saveToUserDefaults()
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .padding()
                        })
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                        .padding(.trailing, 15)
                        .padding(.bottom, 15),
                        alignment: .bottomTrailing
                    )
                }
        }
    }
    
    func deleteCard(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
}
extension ContentView {
    func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "cards")
        }
    }
    
}



struct CardView: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(content)
            Spacer()
        }
        .frame(width: 330, height: 200)
        .background(Color.blue.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct DetailView: View {
    @Binding var content: String
    
    var body: some View {
        TextEditor(text: $content)
            .padding()
            .navigationBarTitle("Note", displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
