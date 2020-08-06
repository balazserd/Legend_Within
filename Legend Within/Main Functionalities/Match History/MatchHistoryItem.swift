//
//  MatchHistoryItem.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 08. 02..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import Combine

struct MatchHistoryItem: View {
    @EnvironmentObject var gameData: GameData
    @ObservedObject var match: Match

    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        return formatter
    }()

    var body: some View {
        let participant = match.details(for: Summoner.getCurrent())

        let itemIdsFirstRow = participant?.firstThreeItemIds
        let itemIdsSecondRow = participant?.secondThreeItemIds
        let trinketItemId = participant?.stats.item6

        let gameTime = dateFormatter.string(from: Date(timeIntervalSince1970: Double(match.timestamp / 1000)))
        let gameDuration = match.details?.gameDuration.toHoursMinutesAndSecondsText()

        let championIconName = gameData.champions[(match.champion)]!.onlyData().image.full

        return HStack(spacing: 3) {
            if gameData.champions.count == 0 || gameData.items.count == 0 {
                EmptyView()
            } else {
                VStack {
                    KFImage(UrlConstants.championIcons(iconName: championIconName).url)
                        .bigItemImageStyle()

                    if gameDuration != nil {
                        Text(gameDuration!)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                VStack {
                    if participant != nil {
                        Text("\(participant!.stats.kills) / \(participant!.stats.deaths) / \(participant!.stats.assists)")
                            .font(.system(size: 19))
                            .bold()

                        Text(gameTime)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                VStack {
                    Spacer()
                    if trinketItemId != nil {
                        KFImage(UrlConstants.itemIcons(itemId: trinketItemId!).url)
                            .smallItemImageStyle()
                    }
                    Spacer()
                }

                VStack(spacing: 3) {
                    self.getItemRow(withItemIdSet: itemIdsFirstRow)
                    self.getItemRow(withItemIdSet: itemIdsSecondRow)
                }
            }
        }
    }

    private func getItemRow(withItemIdSet itemIdSet: [Int?]?) -> some View {
        HStack(spacing: 3) {
            //Needs to be tested separately, or it won't update the view. E.g. (itemIdSet?[i] != nil) is not good.
            if itemIdSet != nil {
                ForEach(0..<3) { i in
                    if itemIdSet![i] != nil {
                        KFImage(UrlConstants.itemIcons(itemId: itemIdSet![i]!).url)
                            .smallItemImageStyle()
                    }
                }
            }
        }
    }
}

extension KFImage {
    func smallItemImageStyle() -> some View {
        self.itemImageStyle(width: 25)
    }

    func bigItemImageStyle() -> some View {
        self.itemImageStyle(width: 50)
    }

    private func itemImageStyle(width w: CGFloat) -> some View {
        self
            .resizable()
            .frame(width: w, height: w)
            .cornerRadius(3)
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
