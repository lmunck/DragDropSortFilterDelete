//
//  ListWithNoList.swift
//  DragDropSortFilterDelete
//
//  Created by Anders Munck on 27/12/2020.
//

import SwiftUI

/*
 
WHAT I WOULD LIKE:
 
Get the same functionality as when rearranging icons on iOS homescreen without using List:

When long-pressing a card, you enter editmode. When in editmode, the cards wiggle, and a xmark is shown in top right corner to delete it.
 
When dragging a card horizontally, the other cards move away to make room, and the scroll follows along.
 
 When dropping a card, the card is moved in the array to the new position and the view is updated.
 
*/


struct ListWithNoList: View {
    
    @State private var editModeActive:Bool = true
    
    
    var body: some View {
        VStack {
            
            // Editmode button
            Button(action: { editModeActive.toggle() }, label: {
                Text(editModeActive ? "Editmode Active" : "Editmode inactive").foregroundColor(.white)
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


