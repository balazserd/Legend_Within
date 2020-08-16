//
//  KFImage+Extensions.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 11..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI

extension KFImage {
    func itemImageStyle(width w: CGFloat) -> some View {
        self.imageStyle(width: w)
            .background(RoundedRectangle(cornerRadius: 3).fill(Color.gray).opacity(0.3))
            .overlay(RoundedRectangle(cornerRadius: 3)
                .stroke(Color.black, lineWidth: 1.5))
    }

    func summonerSpellImageStyle(width w: CGFloat) -> some View {
        self.itemImageStyle(width: w)
    }

    func plainImageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
    }

    func trinketImageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
            .clipShape(Circle())
            .background(Circle().fill(Color.gray).opacity(0.3))
            .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
    }

    func championImageStyle(width w: CGFloat) -> some View {
        self.imageStyle(width: w)
    }

    private func imageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
            .cornerRadius(3)
    }
}

extension Image {
    func itemImageStyle(width w: CGFloat) -> some View {
        self.imageStyle(width: w)
            .background(RoundedRectangle(cornerRadius: 3).fill(Color.gray).opacity(0.3))
            .overlay(RoundedRectangle(cornerRadius: 3)
                .stroke(Color.black, lineWidth: 1.5))
    }

    func summonerSpellImageStyle(width w: CGFloat) -> some View {
        self.itemImageStyle(width: w)
    }

    func plainImageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
    }

    func trinketImageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
            .clipShape(Circle())
            .background(Circle().fill(Color.gray).opacity(0.3))
            .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
    }

    func championImageStyle(width w: CGFloat) -> some View {
        self.imageStyle(width: w)
    }

    private func imageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
            .cornerRadius(3)
    }
}
