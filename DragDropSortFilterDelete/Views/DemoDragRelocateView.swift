//
//  DemoDragRelocateView.swift
//  DragDropSortFilterDelete
//
//  Created by Anders Munck on 30/12/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct GridData: Identifiable, Equatable {
    let id: String
}

//MARK: - Model

class Model: ObservableObject {
    @Published var data: [GridData]

    let columns = [
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
    @State private var changedView: Bool = false

    var body: some View {
        VStack {
            ScrollView(.vertical) {
               LazyVGrid(columns: model.columns, spacing: 5) {
                    ForEach(model.data) { d in
                        GridItemView(d: d)
                            .opacity(dragging?.id == d.id && changedView ? 0 : 1)
                            .onDrag {
                                self.dragging = d
                                changedView = false
                                return NSItemProvider(object: String(d.id) as NSString)
                            }
                            .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging, changedView: $changedView))
                            
                    }
                }.animation(.default, value: model.data)
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.gray.edgesIgnoringSafeArea(.all))
        .onDrop(of: [UTType.text], delegate: DropOutsideDelegate(current: $dragging, changedView: $changedView))
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: GridData
    @Binding var listData: [GridData]
    @Binding var current: GridData?
    @Binding var changedView: Bool
    
    func dropEntered(info: DropInfo) {
        
        if current == nil { current = item }
        
        changedView = true
        
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
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        changedView = false
        self.current = nil
        return true
    }
    
}

struct DropOutsideDelegate: DropDelegate {
    @Binding var current: GridData?
    @Binding var changedView: Bool
        
    func dropEntered(info: DropInfo) {
        changedView = true
    }
    func performDrop(info: DropInfo) -> Bool {
        changedView = false
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
