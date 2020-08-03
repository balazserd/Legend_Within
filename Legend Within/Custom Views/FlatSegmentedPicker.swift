//
//  FlatSegmentedPicker.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 31..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import MobileCoreServices

struct FlatSegmentedPicker<T, Label>: View where T : Equatable, Label : View {

    @Binding var selectedItem: T
    var items: [T]
    var color: Color = Color.blue
    var cell: (T) -> Label
    var onDropCallback: (([NSItemProvider], T) -> Bool)? = nil

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(0..<self.items.count) { i in
                    self.getField(for: self.items[i], coordSpace: proxy, selection: self.$selectedItem)
                        .onDrop(of: [kUTTypeData as String], isTargeted: nil, perform: { itemProvider in
                            if self.onDropCallback != nil {
                                return self.onDropCallback!(itemProvider, self.items[i])
                            }
                            return false
                        })

                    if i + 1 != self.items.count {
                        Rectangle()
                            .fill(self.color)
                            .frame(width: 1)
                    }
                }
            }
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4)
                .stroke(self.color, lineWidth: 1))
        }
    }

    private func getField(for item: T, coordSpace: GeometryProxy, selection: Binding<T>) -> some View {
        let itemCount = CGFloat(self.items.count)

        return self.cell(item)
            .padding(.horizontal, 3).padding(.vertical, 6)
            .frame(maxWidth: (coordSpace.size.width - (itemCount - 1) * 1) / itemCount, maxHeight: .infinity)
            .foregroundColor(item == selection.wrappedValue
                ? .white
                : self.color)
            .background(item == selection.wrappedValue
                ? self.color
                : .white)
            .onTapGesture {
                selection.wrappedValue = item
            }
    }
}

struct FlatSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        FlatSegmentedPicker(selectedItem: .constant("abcde"),
                            items: ["abc", "abcd", "abcde", "abcdef"],
                            cell: { Text("\($0)").bold() })
    }
}
