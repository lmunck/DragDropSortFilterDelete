//
//  DemoDragRelocateView.swift
//  DragDropSortFilterDelete
//
//  Created by Anders Munck on 30/12/2020.
//

import SwiftUI
import UniformTypeIdentifiers

// Question - How do I reset dragging state, when user drops view in same laocation as they started (as if to cancel)

struct GridData: Identifiable, Equatable {
    let id: String
}

//MARK: - Model

class Model: ObservableObject {
    @Published var data: [GridData]

    let columns = [
        //GridItem(.fixed(160)),
        GridItem(.flexible(minimum: 60, maximum: 60))
    ]

    init() {
        data = Array(repeating: GridData(id: "0"), count: 50)
        for i in 0..<data.count {
            data[i] = GridData(id: String("\(i)"))
        }
    }
}

//MARK: - Grid

struct DemoDragRelocateView: View {
    @StateObject private var model = Model()

    @State private var dragging: GridData? // I can't reset this when user drops view ins ame location as drag started

    var body: some View {
        VStack {
            Text(dragging != nil ? "Dragging" : "Dropped")
            ScrollView(.vertical) {
               LazyVGrid(columns: model.columns, spacing: 5) {
                    ForEach(model.data) { d in
                        GridItemView(d: d)
                            .opacity(dragging?.id == d.id ? 0 : 1)
                            .onDrag {
                                self.dragging = d
                                return NSItemProvider(object: String(d.id) as NSString)
                            }
                            .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging))
                            
                    }
                }.animation(.default, value: model.data)
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.gray.edgesIgnoringSafeArea(.all))
        .onDrop(of: [UTType.text], delegate: DropOutsideDelegate(current: $dragging))
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: GridData
    @Binding var listData: [GridData]
    @Binding var current: GridData?

    // None of these methods trigger unless the user has moved the view to another location
    
    func dropEntered(info: DropInfo) {
        
            print("dropEntered")
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        print("dropUpdated")
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        print("performDrop")
        self.current = nil
        return true
    }
    
    func dropExited(info: DropInfo) {
        print("dropExited")
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        print("validateDrop")
        return true
    }
}



struct DropOutsideDelegate: DropDelegate {
    @Binding var current: GridData?
        
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}

//MARK: - GridItem

struct GridItemView: View {
    var d: GridData

    var body: some View {
        VStack {
            Text(String(d.id))
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 60, height: 60)
        .background(Circle().fill(Color.green))
    }
}
