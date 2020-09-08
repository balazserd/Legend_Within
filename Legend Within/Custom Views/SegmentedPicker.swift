//
//  SegmentedPicker.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 07. 31..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI

struct SegmentedPicker<T, Label>: View where T : Equatable, Label : View {

    @Binding var selectedItem: T
    var items: [T]
    var color: Color = Color.blue
    var cell: (T) -> Label

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(self.color)
                    .frame(width: self.maxWidth(in: proxy, itemCount: self.items.count) - 4,
                           height: 28)
                    .padding(2)
                    .shadow(color: Color.gray.opacity(0.7), radius: 4, x: 0, y: 2)
                    .offset(x: CGFloat(self.items.firstIndex(of: self.selectedItem)!) * self.maxWidth(in: proxy, itemCount: self.items.count))
                    .animation(.easeInOut(duration: 0.2))

                HStack(spacing: 0) {
                    ForEach(0..<self.items.count) { i in
                        HStack(spacing: 0) {
                            self.cell(self.items[i])
                                .padding(.horizontal, 3).padding(.vertical, 6)
                                .frame(maxWidth: self.maxWidth(in: proxy, itemCount: self.items.count))
                                .animation(nil)
                                .foregroundColor(self.items[i] == self.selectedItem
                                    ? .white
                                    : self.color)
                                .animation(.easeInOut(duration: 0.2))
                                .onTapGesture {
                                    self.selectedItem = self.items[i]
                                }

                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 1)
                                .padding(.vertical, 8)
                                .opacity(self.needsSeparator(at: i) ? 0.4 : 0.0)
                                .animation(.easeInOut(duration: 0.2))
                        }
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(height: 30)
    }

    private func needsSeparator(at index: Int) -> Bool {
        return index + 1 != self.items.count
            && index != self.items.firstIndex(of: self.selectedItem)!
            && index + 1 != self.items.firstIndex(of: self.selectedItem)!
    }

    private func maxWidth(in proxy: GeometryProxy, itemCount: Int) -> CGFloat {
        let itemCountAsCGFloat = CGFloat(itemCount)
        return (proxy.size.width - (itemCountAsCGFloat - 1) * 1) / itemCountAsCGFloat
    }
}

struct SegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPicker(selectedItem: .constant("abcde"),
                            items: ["abc", "abcd", "abcde", "abcdef"],
                            cell: { Text("\($0)").bold() })
    }
}
