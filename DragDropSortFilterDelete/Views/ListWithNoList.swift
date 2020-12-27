//
//  ListWithNoList.swift
//  DragDropSortFilterDelete
//
//  Created by Anders Munck on 27/12/2020.
//

import SwiftUI

struct ListWithNoList: View {
    
    @State private var editModeActive:Bool = true
    
    
    var body: some View {
        VStack {
            
            // Edit button
            Button(action: { editModeActive.toggle() }, label: {
                Text(editModeActive ? "Active" : "Inactive").foregroundColor(.white)
            })
            
            // List of cards
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach (Contact.testArray) { contact in
                        ZStack {
                            Card(editModeActive: $editModeActive, contact: contact)
                            Image(systemName: "xmark.circle.fill")
                                .background(Circle().fill(Color.white))
                                .frame(maxWidth: .infinity, idealHeight: 100, maxHeight: .infinity, alignment: .topTrailing)
                                .foregroundColor(.red)
                        }
                        .rotationEffect(editModeActive ? .degrees(4) : .degrees(0))
                        .frame(height:90)
                        .onLongPressGesture {
                            self.editModeActive.toggle()
                        }
                    }
                }
            }
        }
        .padding(3)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
    }
}

struct ListWithNoList_Previews: PreviewProvider {
    static var previews: some View {
        ListWithNoList()
    }
}


