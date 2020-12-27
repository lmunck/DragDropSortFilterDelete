//
//  Card.swift
//  DragDropSortFilterDelete
//
//  Created by Anders Munck on 27/12/2020.
//

import SwiftUI

struct Card: View {
    
    @Binding var editModeActive: Bool
    @State private var offset = CGSize.zero
    var contact: Contact
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(contact.name)
                }.font(.body)
                HStack {
                    Text("Age").foregroundColor(.gray)
                    Spacer()
                    Text("\(contact.age)")
                }
                HStack {
                    Text("Active").foregroundColor(.gray)
                    Spacer()
                    Text("\(contact.active ? "Yes" : "No")")
                }
                HStack {
                    Text("Category").foregroundColor(.gray)
                    Spacer()
                    switch contact.category {
                    case .business:
                        Text("Business")
                    case .personal:
                        Text("Personal")
                    }
                }
            }
        }
        .font(.caption)
        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
        .background(Color.white.cornerRadius(8))
        .frame(width: 130)
        .offset(x: editModeActive ? offset.width : 0)
        .rotationEffect(editModeActive ? .degrees(3) : .degrees(0))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }

                .onEnded { _ in
                    if abs(self.offset.width) > 100 {
                        // remove the card
                    } else {
                        self.offset = .zero
                    }
                }
        )
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(editModeActive: .constant(true), contact: Contact.testContact)
    }
}


// MODEL

struct Contact:Identifiable {
    var id: Int
    var name: String
    var age: Int
    var active: Bool
    var category: Category
    
}

extension Contact {
    
    static var testContact:Contact = Contact(id: 1, name: "Jonas", age: 15, active: true, category: .personal)
    
    static var testArray = [
        testContact,
        Contact(id: 2, name: "Piper", age: 55, active: true, category: .business),
        Contact(id: 3, name: "William", age: 30, active: false, category: .personal),
        Contact(id: 4, name: "Ashok", age: 78, active: true, category: .personal),
        Contact(id: 5, name: "Ming", age: 18, active: false, category: .business),
        Contact(id: 6, name: "Kathrine", age: 27, active: true, category: .business),
        Contact(id: 7, name: "Myriam", age: 39, active: false, category: .personal),
        Contact(id: 8, name: "Madhavi", age: 47, active: true, category: .personal),
        Contact(id: 9, name: "Etienne", age: 49, active: true, category: .business),
        Contact(id: 10, name: "Leben", age: 67, active: true, category: .business)
    
    ]
}

enum Category {
    case personal
    case business
}


