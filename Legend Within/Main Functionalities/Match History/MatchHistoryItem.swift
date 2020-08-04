//
//  MatchHistoryItem.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct MatchHistoryItem: View {
    @EnvironmentObject var gameData: GameData
    @ObservedObject var match: Match

    var body: some View {
        let participant = match.details(for: Summoner.getCurrent())

        let itemIdsFirstRow = [participant?.stats.item1, participant?.stats.item2, participant?.stats.item3]
        let itemIdsSecondRow = [participant?.stats.item4, participant?.stats.item5, participant?.stats.item6]

        let championIconName = gameData.champions["\(match.champion)"]!.onlyData().image.full

        return HStack {
            if gameData.champions.count == 0 || gameData.items.count == 0 {
                EmptyView()
            } else {
                KFImage(UrlConstants.championIcons(iconName: championIconName).url)
                    .resizable()
                    .frame(width: 50, height: 50)

                VStack {
                    if participant != nil {
                        Text("\(participant!.stats.kills) / \(participant!.stats.deaths) / \(participant!.stats.assists)")
                    }
                }

                Spacer()

                VStack {
                    HStack {
                        ForEach(0..<3) { i in
                            if itemIdsFirstRow[i] != nil {
                                KFImage(UrlConstants.itemIcons(itemId: itemIdsFirstRow[i]!).url)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }

                    HStack {
                        ForEach(0..<3) { i in
                            if itemIdsSecondRow[i] != nil {
                                KFImage(UrlConstants.itemIcons(itemId: itemIdsSecondRow[i]!).url)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MatchHistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        let decoder = JSONDecoder()
        guard
            let url_match = Bundle.main.url(forResource: "MatchExample",
                                                  withExtension: "json"),
            let url_matchDetails = Bundle.main.url(forResource: "MatchDetailsExample",
                                                        withExtension: "json")
            else { fatalError() }

        let match = try! decoder.decode(Match.self, from: Data(contentsOf: url_match))
        let matchDetails = try! decoder.decode(MatchDetails.self, from: Data(contentsOf: url_matchDetails))

        match.details = matchDetails

        return MatchHistoryItem(match: match)
    }
}
