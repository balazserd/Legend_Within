//
//  MatchHistoryPage+LeftSide.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 09. 14..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

extension MatchHistoryPage {

    struct LeftSide: View {
        @EnvironmentObject var gameData: GameData

        var participant: MatchDetails.Participant

        var body: some View {
            let championIconName = gameData.champions[(participant.championId)]!.onlyData().image.full

            return VStack(spacing: 3.5) {
                KFImage(FilePaths.championIcon(fileName: championIconName).path)
                    .championImageStyle(width: 55)

                HStack(spacing: 4) {
                    KFImage(FilePaths.summonerSpellIcon(fileName: gameData.summonerSpells[participant.spell1Id]!.image.full).path)
                        .summonerSpellImageStyle(width: 25)

                    KFImage(FilePaths.summonerSpellIcon(fileName: gameData.summonerSpells[participant.spell2Id]!.image.full).path)
                        .summonerSpellImageStyle(width: 25)
                }
                .padding(.leading, -0.5)
            }
        }
    }
    
}
