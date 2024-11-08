//
//  Test.swift
//  Tracebook
//
//  Created by Marcus Painter on 08/11/2024.
//

import Foundation
import SwiftUI

struct ContentView2: View {
    @StateObject var store: Store = .init()

    var body: some View {
        VStack {
            Button("Rename") {
                if let book = store.items.first {
                    // This line does not update the first row's text.
                    //book.title = "Lord of the Rings"
                    store.changeTitle(for: book, newTitle: "Lord of the Rings")
                    //book.changeTitle(newTitle: "Lord of the Rings")
                    store.items.forEach { print($0.title) }
                }
            }

            List(store.items, id: \.title) { book in
                Text(book.title)
            }
                
            
        }
    }
}

#Preview {
     ContentView2()
}

class Book: ObservableObject {
    @Published var title: String = ""

    init(title: String) {
        self.title = title
    }
    
    func changeTitle(newTitle: String) {
      objectWillChange.send() // emits a change from the Store
      self.title = newTitle
    }
}

class Store: ObservableObject {
    @Published var items: [Book]

    init() {
        items = [
            Book(title: "Harry Potter 1"),
            Book(title: "Harry Potter 2"),
            Book(title: "Harry Potter 3")
        ]
    }
    
    func changeTitle(for book: Book, newTitle: String) {
      objectWillChange.send() // emits a change from the Store
      book.title = newTitle
    }
}

extension Book: Hashable {
    
    // Implement Equatable protocol by defining the equality criteria
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
