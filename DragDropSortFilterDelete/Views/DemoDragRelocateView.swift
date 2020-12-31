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

    @State private var dragging: GridData?

    var body: some View {
        ScrollView(.horizontal) {
           LazyHGrid(rows: model.columns, spacing: 5) {
            
                ForEach(model.data) { d in
                    GridItemView(d: d)
                        .opacity(dragging?.id == d.id ? 0 : 1)
                        .onDrag {
                            self.dragging = d
                            return NSItemProvider(object: String(d.id) as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging))
                        
                }.onInsert(of: [UTType.text], perform: drop)
            }.animation(.default, value: model.data)
        }.onDrop(of: [UTType.text], delegate: DropOutsideDelegate(current: $dragging))
    }
    
    private func drop(at index: Int, _ items: [NSItemProvider]) {
            for item in items {
                _ = item.loadObject(ofClass: NSString.self) { string, _ in
                    DispatchQueue.main.async {
                        
                        string.map { self.model.data.insert(GridData(id: $0 as! String), at: index) }
                    }
                }
            }
        }
}

struct DragRelocateDelegate: DropDelegate {
    let item: GridData
    @Binding var listData: [GridData]
    @Binding var current: GridData?

    func dropEntered(info: DropInfo) {
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
        self.current = nil
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
