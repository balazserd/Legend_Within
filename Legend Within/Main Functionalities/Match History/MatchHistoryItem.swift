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
        let kdaForUser = match.kdaForUser()
        let iconName = gameData.champions["\(match.champion)"]!.onlyData().image.full

        return HStack {
            KFImage(UrlConstants.championIcons(iconName: iconName).url)
                .resizable()
                .frame(width: 50, height: 50)

            VStack {
                if kdaForUser.count != 0 {
                    Text("\(kdaForUser["k"]!) / \(kdaForUser["d"]!) / \(kdaForUser["a"]!)")
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
