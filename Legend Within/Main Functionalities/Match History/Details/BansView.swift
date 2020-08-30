//
//  BansView.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 30..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension MatchDetailsPage {

    struct BansView: View {
        @EnvironmentObject var gameData: GameData
        var bans: [Ban]

        var body: some View {
            ForEach(bans, id: \.championId) { ban in
                VStack {
                    if ban.championId != -1 {
                        KFImage(FilePaths.championIcon(fileName: self.gameData.champions[ban.championId]!.onlyData().image.full).path)
                            .championImageStyle(width: 30)
                            .opacity(0.9)
                            .overlay(Image("MatchHistoryIcon_BanX")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .offset(x: 10, y: -10))
                    }
                }
            }
        }
    }

}
