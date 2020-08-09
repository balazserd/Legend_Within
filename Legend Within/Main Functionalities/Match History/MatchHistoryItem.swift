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
        formatter.dateFormat = "MMM dd, HH:mm"
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
            if gameData.champions.count == 0
                || gameData.items.count == 0
                || gameData.runePaths.count == 0
                || gameData.maps.count == 0
                || gameData.queues.count == 0 {
                EmptyView()
            } else {
                VStack {
                    KFImage(FilePaths.championIcon(fileName: championIconName).path)
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
                    }
                }

                Spacer()

                VStack {
                    HStack(spacing: 3) {
                        VStack {
                            Spacer()
                            if trinketItemId != nil {
                                KFImage(UrlConstants.itemIcons(itemId: trinketItemId!).url)
                                    .smallItemImageStyle()
                            }
                            Spacer()
                        }

                        VStack(spacing: 3) {
                            HStack(spacing: 3) {
                                if itemIdsFirstRow != nil {
                                    KFImage(FilePaths.itemIcon(id: itemIdsFirstRow![0]!).path).smallItemImageStyle()
                                    KFImage(FilePaths.itemIcon(id: itemIdsFirstRow![1]!).path).smallItemImageStyle()
                                    KFImage(FilePaths.itemIcon(id: itemIdsFirstRow![2]!).path).smallItemImageStyle()
                                }
                            }
                            HStack(spacing: 3) {
                                if itemIdsSecondRow != nil {
                                    KFImage(FilePaths.itemIcon(id: itemIdsSecondRow![0]!).path).smallItemImageStyle()
                                    KFImage(FilePaths.itemIcon(id: itemIdsSecondRow![1]!).path).smallItemImageStyle()
                                    KFImage(FilePaths.itemIcon(id: itemIdsSecondRow![2]!).path).smallItemImageStyle()
                                }
                            }
                        }
                    }

                    Text(gameTime)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(participant?.stats.win ?? false ? Color.green5 : Color.red3)
                .shadow(color: Color.gray.opacity(0.8), radius: 4, x: 0, y: 2))
        .padding(.bottom, 2).padding(.top, -2)

    }
}

private extension KFImage {
    func smallItemImageStyle() -> some View {
        self.itemImageStyle(width: 25)
            .background(RoundedRectangle(cornerRadius: 3).fill(Color.gray).opacity(0.5))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.black, lineWidth: 1.5))
    }

    func bigItemImageStyle() -> some View {
        self.itemImageStyle(width: 55)
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
